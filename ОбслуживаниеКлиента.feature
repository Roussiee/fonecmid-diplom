﻿#language: ru

@tree
@exportscenarios
@ТипШага: Создание документов
@Описание: Проверка корректности создания нового документа Обслуживание клиента
@ПримерИспользования: И Я проверяю создание нового документа Обслуживание клиента по организации "НаименованиеОрганизация" с клиентом "НаименованиеКонтрагент" и договором "НаименованиеДоговор"

Функционал: Проверка создания документа Обслуживание клиента

Как тестировщик-автоматизатор я хочу
автоматизировать процесс проверки создания нового документа Обслуживание клиента
чтобы сократить время на ручное регрессионное тестированиее и оперативно обнаруживать ошибки в данном процессе    


Сценарий: Я проверяю создание нового документа Обслуживание клиента с клиентом "НаименованиеКонтрагент", договором "НаименованиеДоговор" и специалистом "НаименованиеСпециалист"
* Я нажимаю на меню "Добавленные объекты"
	И В командном интерфейсе я выбираю 'Добавленные объекты' 'Обслуживание клиента'
* Я нажимаю на кнопку "Создать"
	И я нажимаю на кнопку с именем 'ФормаСоздать'
	Тогда открылось окно 'Обслуживание клиента (создание)'
* Я вижу автоматически заполненное поле “Дата” текущей датой
	И поле с именем "Дата" заполнено
* Я выбираю в поле "Специалист" специалиста
	И я нажимаю кнопку выбора у поля с именем "Специалист"
	Тогда открылось окно 'Выбор пользователя'
	И в таблице "ПользователиСписок" я перехожу к строке:
		| 'Полное имя'               |
		| '[НаименованиеСпециалист]' |
	И в таблице "ПользователиСписок" я выбираю текущую строку
* Я заполняю поле "ДатаПроведенияРабот"	
	И в поле с именем 'ДатаПроведенияРабот' я ввожу текст '25.01.2025'
* Я заполняю поле "ОписаниеПроблемы"		
	И в поле с именем 'ОписаниеПроблемы' я ввожу текст 'не открывается программа'
* Я выбираю в поле "Клиент" клиента
	И я нажимаю кнопку выбора у поля с именем "Клиент"
	Тогда открылось окно 'Контрагенты'
	И в таблице "Список" я перехожу к строке
		| 'Наименование'             |
		| '[НаименованиеКонтрагент]' |
	И в таблице "Список" я выбираю текущую строку
* Я выбираю в поле "Договор" договор
	И я нажимаю кнопку выбора у поля с именем "Договор"
	Тогда открылось окно 'Договоры контрагентов'
	И в таблице "Список" я перехожу к строке:
		| 'Наименование'          |
		| '[НаименованиеДоговор]' |
	И в таблице "Список" я выбираю текущую строку
* Я заполняю поле "ВремяНачалаРаботПлан"	
	И в поле с именем 'ВремяНачалаРаботПлан' я ввожу текст '09:00:00'
	И я перехожу к следующему реквизиту
* Я заполняю поле "ВремяОкончанияРаботПлан"	
	И в поле с именем 'ВремяОкончанияРаботПлан' я ввожу текст '18:00:00'
* Я создаю глобальную переменную
	И я выполняю код встроенного языка
	"""bsl
		КонтекстСохраняемый.Вставить("ГлСсылкаНаДокумент","");
	"""	
* Я нажимаю кнопку "Провести" 
	И я нажимаю на кнопку с именем 'ФормаПровести'
	Тогда поле с именем "Номер" заполнено
	И я удаляю переменную 'НомерДокумента'
	И я запоминаю значение поля с именем "Номер" как "$НомерДокумента$"
	И я сохраняю навигационную ссылку текущего окна в переменную "СсылкаНаДокумент"
	И я выполняю код встроенного языка
	"""bsl
		КонтекстСохраняемый.Вставить("ГлСсылкаНаДокумент","$СсылкаНаДокумент$");
	"""	
* Я нажимаю кнопку "Закрыть"
	И я закрываю окно 'Обслуживание клиента * от *'
	И я жду закрытия окна 'Обслуживание клиента (создание) *' в течение 10 секунд
	Тогда открылось окно 'Обслуживание клиента'
* Я вижу в форме списка созданный документ с уникальным номером и текущей датой
	И таблица "Список" содержит строки по шаблону:
		| 'Дата'        | 'Номер'            | 'Клиент'                   |
		| '*.*.* *:*:*' | '$НомерДокумента$' | '[НаименованиеКонтрагент]' |
