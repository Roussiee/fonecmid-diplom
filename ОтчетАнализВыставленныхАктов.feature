﻿#language: ru

@tree
@exportscenarios
@ТипШага: Создание отчета
@Описание: Сравнение результата отчета с эталоном
@ПримерИспользования: И Я запускаю отчет Анализ выставленных актов

Функционал: Сравнение отчета Анализ выставленных актов с эталоном

Как Разработчик я хочу
Сравнить отчет Анализ выставленных актов с эталоном , чтобы сранить данные     

Сценарий: Я запускаю отчет анализ выставленных актов
* Я нажимаю на меню "Добавленные объекты" и выбираю отчет "Анализ выставленных актов"
	И В командном интерфейсе я выбираю 'Добавленные объекты' 'Анализ выставленных актов'
	Тогда открылось окно 'Основной'
* Я нажимаю кнопку "Сформировать"
	И я нажимаю на кнопку с именем 'СформироватьОтчет'
* Я проверяю табличный документ с эталоном
	Дано Табличный документ 'ОтчетТабличныйДокумент' равен макету "Эталон"
