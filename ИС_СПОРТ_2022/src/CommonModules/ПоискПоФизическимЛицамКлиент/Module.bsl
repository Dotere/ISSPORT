
Процедура ПоискПоФизическимЛицам(ЭтотОбъект) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПоискПоФизическимЛицамЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ФормаПоискаФизическогоЛица",,ЭтотОбъект,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры	