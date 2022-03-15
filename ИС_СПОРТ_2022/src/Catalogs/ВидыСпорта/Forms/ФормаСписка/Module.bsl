
&НаКлиенте
Процедура ПодобратьИзРеестраВидовСпорта(Команда)
    
    ПараметрыВыбора = Новый Структура("РежимВыбора,ЗакрыватьПриВыборе", Истина, Истина);
    Оповещение = Новый ОписаниеОповещения("ОбработкаВыбранногоЭлемента",ЭтаФорма);
    
    ОткрытьФорму("Справочник.РеестрВидовСпорта.ФормаВыбора",ПараметрыВыбора,ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
    
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбранногоЭлемента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
    
    Если НЕ РезультатЗакрытия = Неопределено Тогда
    
    	  ПараметрыЗаполнения = Новый Структура("Наименование, ВидСпортаПоРеестру, Владелец") ;
          ЗаполнитьПараметры(ПараметрыЗаполнения,РезультатЗакрытия);
          ОткрытьФорму("Справочник.ВидыСпорта.Форма.ФормаЭлемента",ПараметрыЗаполнения,ЭтаФорма);
          
    КонецЕсли; 
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметры(ПараметрыЗаполнения,Источник)
    
         ПараметрыЗаполнения.Владелец = ПараметрыСеанса.ТекущаяОрганизация;
         ПараметрыЗаполнения.Наименование = Источник.Наименование;
         ПараметрыЗаполнения.ВидСпортаПоРеестру = Источник.Ссылка;
    
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ТекВладелец = ПараметрыСеанса.ТекущаяОрганизация;
    ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", ТекВладелец, , , Не ТекВладелец.Пустая());
    
КонецПроцедуры
