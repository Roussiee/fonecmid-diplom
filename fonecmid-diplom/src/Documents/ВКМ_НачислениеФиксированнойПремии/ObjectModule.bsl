#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
 
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	СформироватьДвижения();
 	
	РассчитатьНДФЛ();
	
	СформироватьВзаиморасчетыССотрудниками()

КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвижения()
	
	СформироватьДвиженияДополнительныеНачисления();
	СформироватьДвиженияУдержания();
    	
	Движения.ВКМ_ДополнительныеНачисления.Записать();
	Движения.ВКМ_Удержания.Записать();
	
КонецПроцедуры


Процедура СформироватьДвиженияДополнительныеНачисления()
	
	// регистр ВКМ_ДополнительныеНачисления
	Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
	
	Для Каждого СтрокаСписокСотрудников Из СписокСотрудников Цикл
		
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, СтрокаСписокСотрудников);
		Движение.Сторно = Ложь;
		Движение.Сотрудник = СтрокаСписокСотрудников.Сотрудник;
		Движение.Результат = СтрокаСписокСотрудников.СуммаПремии;
		Движение.Показатель = СтрокаСписокСотрудников.СуммаПремии;
		Движение.ПериодРегистрации = Дата;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.ФиксированнаяПремия;
		
	КонецЦикла;
	
	Движения.ВКМ_ДополнительныеНачисления.Записать();
	
КонецПроцедуры


Процедура СформироватьДвиженияУдержания()
	
	// регистр ВКМ_Удержания
	Движения.ВКМ_Удержания.Записывать = Истина;
	
	Для Каждого СтрокаСписокСотрудников Из СписокСотрудников Цикл
		
		Движение = Движения.ВКМ_Удержания.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, СтрокаСписокСотрудников);
		Движение.ПериодРегистрации = Дата;
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
		
	КонецЦикла;
	
	Движения.ВКМ_Удержания.Записать();
	
КонецПроцедуры	


Процедура РассчитатьНДФЛ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.НомерСтроки КАК НомерСтроки,
		|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
		|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РезультатБаза КАК Показатель,
		|	ВЫБОР
		|		КОГДА ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РезультатБаза <> 0
		|			ТОГДА ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РезультатБаза / 100 * 13
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Результат
		|ИЗ
		|	РегистрРасчета.ВКМ_Удержания.БазаВКМ_ДополнительныеНачисления(&Измерение, &Измерение, , Регистратор = &Ссылка) КАК ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления";
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	
	Запрос.УстановитьПараметр("Измерение", Измерения); 
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать(); 
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Движение = Движения.ВКМ_Удержания[ВыборкаДетальныеЗаписи.НомерСтроки - 1];
		
		ЗаполнитьЗначенияСвойств(Движение, ВыборкаДетальныеЗаписи);
		
		Движение.ПериодРегистрации = Дата;
		Движение.Показатель = ВыборкаДетальныеЗаписи.Показатель;
		
	КонецЦикла;
	
	Движения.ВКМ_Удержания.Записать();
	
КонецПроцедуры


Процедура СформироватьВзаиморасчетыССотрудниками()	  	
	  	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	   "ВЫБРАТЬ
	   |	ВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
	   |	СУММА(ВКМ_ДополнительныеНачисления.Результат) КАК Показатель,
	   |	СУММА(ВКМ_Удержания.Результат) КАК Результат,
	   |	СУММА(ВКМ_ДополнительныеНачисления.Результат - ВКМ_Удержания.Результат) КАК СуммаКВыплате
	   |ИЗ
	   |	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
	   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
	   |		ПО ВКМ_ДополнительныеНачисления.Сотрудник = ВКМ_Удержания.Сотрудник
	   |			И ВКМ_ДополнительныеНачисления.Регистратор = ВКМ_Удержания.Регистратор
	   |ГДЕ
	   |	ВКМ_ДополнительныеНачисления.Регистратор = &Ссылка
	   |
	   |СГРУППИРОВАТЬ ПО
	   |	ВКМ_ДополнительныеНачисления.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка); 
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.ДобавитьПриход();
		
		ЗаполнитьЗначенияСвойств(Движение, ВыборкаДетальныеЗаписи);
		Движение.Период = Дата;
		Движение.Сумма = ВыборкаДетальныеЗаписи.СуммаКВыплате; 
		
	КонецЦикла;
	
   	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


