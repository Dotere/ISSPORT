#Область ПроцедурыПриЗаписиОбъектов

Процедура ОбработкаПриЗаписиВРегистрСведенийСоставСемьиПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если НЕ Источник.Количество() = 0 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запись_ = Источник[0];
		МассивОрганизаций = СформироватьМассивОрганизаций(Запись_.Спортсмен);
		ФизическоеЛицо = Запись_.Родитель.ФизическоеЛицо;
		
		Для Каждого Организация Из МассивОрганизаций Цикл
			СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(ФизическоеЛицо,Организация); 			
		КонецЦикла;
	
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПриЗаписиВСправочникСпортсменПриЗаписи(Источник, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущаяОрганизация = ПараметрыСеанса.ТекущаяОрганизация;
	
	Если НЕ ТекущаяОрганизация = Справочники.Организации.ПустаяСсылка() Тогда
		СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(Источник.ФизическоеЛицо,ТекущаяОрганизация);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Спортсмен", Источник.Ссылка);
	Запрос.УстановитьПараметр("ТекущаяОрганизация", ТекущаяОрганизация);
	
	Если ТекущаяОрганизация = Справочники.Организации.ПустаяСсылка() Тогда
		
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		           |	СоставУчащихсяСпортивногоУчреждения.Организация КАК Организация
		           |ПОМЕСТИТЬ ВТ_СписокОрганизаций
		           |ИЗ
		           |	РегистрСведений.СоставУчащихсяСпортивногоУчреждения КАК СоставУчащихсяСпортивногоУчреждения
		           |ГДЕ
		           |	СоставУчащихсяСпортивногоУчреждения.Спортсмен = &Спортсмен
		           |;";
	Иначе
		
		Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		           |	Организации.Ссылка КАК Организация
		           |ПОМЕСТИТЬ ВТ_СписокОрганизаций
		           |ИЗ
		           |	Справочник.Организации КАК Организации
		           |ГДЕ
		           |	Организации.Ссылка = &ТекущаяОрганизация
				   |;";
	КонецЕсли;	
	Запрос.Текст = Запрос.Текст +"
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ФизическиеЛица.Ссылка КАК ФизЛицо
	               |ПОМЕСТИТЬ ВТ_ФизЛица
	               |ИЗ
	               |	РегистрСведений.СоставыСемейСпортсменов КАК СоставыСемейСпортсменов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	               |		ПО СоставыСемейСпортсменов.Родитель.ФизическоеЛицо = ФизическиеЛица.Ссылка
	               |ГДЕ
	               |	СоставыСемейСпортсменов.Спортсмен = &Спортсмен
	               |	И НЕ ФизическиеЛица.Ссылка ЕСТЬ NULL
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ФизЛица.ФизЛицо КАК ФизЛицо,
	               |	ВТ_СписокОрганизаций.Организация КАК Организация
	               |ПОМЕСТИТЬ ВТ_ТаблицаВозможныхСоответсвий
	               |ИЗ
	               |	ВТ_ФизЛица КАК ВТ_ФизЛица
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СписокОрганизаций КАК ВТ_СписокОрганизаций
	               |		ПО (ИСТИНА)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ВТ_ТаблицаВозможныхСоответсвий.ФизЛицо КАК ФизЛицо,
	               |	ВТ_ТаблицаВозможныхСоответсвий.Организация КАК Организация
	               |ИЗ
	               |	ВТ_ТаблицаВозможныхСоответсвий КАК ВТ_ТаблицаВозможныхСоответсвий
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствияФизическихЛицИОрганизаций КАК СоответствияФизическихЛицИОрганизаций
	               |		ПО ВТ_ТаблицаВозможныхСоответсвий.ФизЛицо = СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо
	               |			И ВТ_ТаблицаВозможныхСоответсвий.Организация = СоответствияФизическихЛицИОрганизаций.Организация
	               |ГДЕ
	               |	СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо ЕСТЬ NULL";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат
	Иначе
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(Выборка.ФизЛицо, Выборка.Организация);
		КонецЦикла;	
		
	КонецЕсли;	
	
    УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбработкаПроведенияЗаявленияНаПриемВСпортивноеУчреждениеОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ФизическоеЛицоСпортсмен = Источник.Спортсмен.ФизическоеЛицо;
	СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(ФизическоеЛицоСпортсмен,Источник.Организация);
	
	Если НЕ Источник.Родитель = Справочники.РодителиЗаконныеПредставителиСпортсменов.ПустаяСсылка() Тогда
		
		ФизическоеЛицоРодитель = Источник.Родитель.ФизическоеЛицо;
		СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(ФизическоеЛицоРодитель, Источник.Организация); 

	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбработкаПриЗаписиВСправочникТренерыПриЗаписи(Источник, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	ТекущаяОрганизация = ПараметрыСеанса.ТекущаяОрганизация;
	
	Если ТекущаяОрганизация = Справочники.Организации.ПустаяСсылка() Тогда
		Возврат
	КонецЕсли;
	
	СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(Источник.ФизическоеЛицо, ТекущаяОрганизация);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбработкаПриЗаписиВСправочникФизическиеЛицаПриЗаписи(Источник, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	ТекущаяОрганизация = ПараметрыСеанса.ТекущаяОрганизация;
	
	Если ТекущаяОрганизация = Справочники.Организации.ПустаяСсылка() Тогда
		Возврат
	КонецЕсли;
	
	СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(Источник, ТекущаяОрганизация);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьМассивОрганизаций(Спортсмен)
	
	ТекущаяОрганизация = ПараметрыСеанса.ТекущаяОрганизация;
	
	МассивОрганизаций = Новый Массив;
	Если ТекущаяОрганизация = Справочники.Организации.ПустаяСсылка() Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Спортсмен", Спортсмен);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоставУчащихсяСпортивногоУчреждения.Организация КАК Организация
		|ИЗ
		|	РегистрСведений.СоставУчащихсяСпортивногоУчреждения КАК СоставУчащихсяСпортивногоУчреждения
		|ГДЕ
		|	СоставУчащихсяСпортивногоУчреждения.Спортсмен = &Спортсмен";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивОрганизаций.Добавить(Выборка.Организация);
		КонецЦикла;	
		
	Иначе
		
		МассивОрганизаций.Добавить(ТекущаяОрганизация);
		
	КонецЕсли;
	
	Возврат МассивОрганизаций
	
КонецФункции	

Процедура СоздатьЗаписьВРегистреСоответсвияФизическихЛицИОрганизаций(ФизическоеЛицо, Организация)
	
	НаборЗаписей = РегистрыСведений.СоответствияФизическихЛицИОрганизаций.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо.Ссылка);
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		
		Запись_ = НаборЗаписей.Добавить();
		Запись_.ФизическоеЛицо = ФизическоеЛицо.Ссылка;
		Запись_.Организация    = Организация;
		
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти














