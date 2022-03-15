// {Рарус adilas #1.0.0.2 -Исправления по SonarQube 2021.04.23
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
         Возврат;
    КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	УчетСпортсменовСервер.ЗаполнитьРеквизит(ЭтотОбъект, "Ответственный", ПараметрыСеанса.ТекущийПользователь);	
    
    ПараметрыОписанияКраткогоСостава = СформироватьПараметрыПостроенияСтроки();
    СтрокаОписаниКраткогоСостава = УчетСпортсменовСервер.СформироватьСтрокуПоМассиву(ПараметрыОписанияКраткогоСостава);
    
    УчетСпортсменовСервер.ЗаполнитьРеквизит(ЭтотОбъект, "КраткийСоставСпортсмены", СтрокаОписаниКраткогоСостава);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// {Рарус adilas #15655 -Тестирование Релиза Альфа Спорт 1.0.0.1. Приказ на отчисление из спортивного учреждения 2021.04.15
	//
	Если ОбменДанными.Загрузка Тогда
         Возврат;
    КонецЕсли;
	
	ВыполнитьПроверкуПередПроведением(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// }Рарус adilas #15655 -Тестирование Релиза Альфа Спорт 1.0.0.1. Приказ на отчисление из спортивного учреждения 2021.04.15
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ПроведениеСервер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "СоставУчащихсяСпортивногоУчреждения");

	Движения.Записать();

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Движения.Записать();

	ПроведениеСервер.ВыполнитьКонтрольРезультатовОтменыПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПараметрыПостроенияСтроки()

	   ТЗСпортсменов = Спортсмены.Выгрузить();
       ТЗСпортсменов.Свернуть("Спортсмен");
       ТЗСпортсменов.Сортировать("Спортсмен");
       
       СтруктураПараметров = Новый Структура;
       СтруктураПараметров.Вставить("МассивЗначений",ТЗСпортсменов.ВыгрузитьКолонку("Спортсмен"));
       СтруктураПараметров.Вставить("ОграниченнаяДлина",Истина);
       СтруктураПараметров.Вставить("ДлинаСтроки",1000);

       Возврат СтруктураПараметров;
       
КонецФункции

// {Рарус adilas #Отчисление из спортивного учреждения -11632 2020.12.10
//{ lobash IN-10427 16.12.2020 Проверка на зачисленных и отчисленных
Процедура ВыполнитьПроверкуПередПроведением(Отказ);
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаСпортсменов"     , Спортсмены.Выгрузить());
	Запрос.УстановитьПараметр("Дата"           		   , Новый Граница(ДатаДокумента, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Организация"            , Организация);
	Запрос.УстановитьПараметр("ВидСпорта"              , ВидСпорта);
	Запрос.УстановитьПараметр("Ссылка"                 , Ссылка);
	Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	ТаблицаСпортсменов.Спортсмен КАК Спортсмен
	                |ПОМЕСТИТЬ ВТ_ТаблицаСпортсменов
	                |ИЗ
	                |	&ТаблицаСпортсменов КАК ТаблицаСпортсменов
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен КАК Спортсмен,
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаНачалаОбучения КАК ДатаНачалаОбучения
	                |ПОМЕСТИТЬ ВТ_СоставУчащихся
	                |ИЗ
	                |	РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(&Дата, ВидСпорта = &ВидСпорта) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
	                |ГДЕ
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаНачалаОбучения <> ДАТАВРЕМЯ(1, 1, 1)
	                |
	                |ИНДЕКСИРОВАТЬ ПО
	                |	Спортсмен
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен КАК Спортсмен,
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения КАК ДатаОкончанияОбучения
	                |ПОМЕСТИТЬ ВТ_СоставОтчисленных
	                |ИЗ
	                |	РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(&Дата, ВидСпорта = &ВидСпорта) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
	                |ГДЕ
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения <> ДАТАВРЕМЯ(1, 1, 1)
	                |
	                |ИНДЕКСИРОВАТЬ ПО
	                |	Спортсмен
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	ВТ_ТаблицаСпортсменов.Спортсмен КАК Спортсмен
	                |ИЗ
	                |	ВТ_ТаблицаСпортсменов КАК ВТ_ТаблицаСпортсменов
	                |ГДЕ
	                |	ВТ_ТаблицаСпортсменов.Спортсмен В
	                |			(ВЫБРАТЬ
	                |				ВТ_СоставОтчисленных.Спортсмен КАК Спортсмен
	                |			ИЗ
	                |				ВТ_СоставОтчисленных КАК ВТ_СоставОтчисленных)
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	ВТ_ТаблицаСпортсменов.Спортсмен КАК Спортсмен
	                |ИЗ
	                |	ВТ_ТаблицаСпортсменов КАК ВТ_ТаблицаСпортсменов
	                |ГДЕ
	                |	НЕ ВТ_ТаблицаСпортсменов.Спортсмен В
	                |				(ВЫБРАТЬ
	                |					ВТ_СоставУчащихся.Спортсмен КАК Спортсмен
	                |				ИЗ
	                |					ВТ_СоставУчащихся КАК ВТ_СоставУчащихся)
	                |	И НЕ ВТ_ТаблицаСпортсменов.Спортсмен В
	                |				(ВЫБРАТЬ
	                |					ВТ_СоставОтчисленных.Спортсмен КАК Спортсмен
	                |				ИЗ
	                |					ВТ_СоставОтчисленных КАК ВТ_СоставОтчисленных)";					
			
	Результат = Запрос.ВыполнитьПакет();
		
	тзОтчисленныеСпортсмены = Результат[3].Выгрузить();
	Если не тзОтчисленныеСпортсмены.Количество() = 0 Тогда
		Отказ = Истина;
		Для Каждого строкаСпортсмен Из тзОтчисленныеСпортсмены Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Спортсмен %1 не обучается в спортивном учреждении (не зачислен или отчислен из учреждения).'"), строкаСпортсмен.Спортсмен);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЦикла;	
	КонецЕсли;
	
	тзЗачисленныеСпортсмены = Результат[4].Выгрузить();
	Если НЕ тзЗачисленныеСпортсмены.Количество() = 0 Тогда
		Отказ = Истина;
		Для Каждого строкаСпортсмен Из тзЗачисленныеСпортсмены Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Спортсмен %1 не обучается в спортивном учреждении (не зачислен или отчислен из учреждения).'"), строкаСпортсмен.Спортсмен);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЦикла;	
	КонецЕсли;
		
	//} lobash IN-10427 16.12.2020
КонецПроцедуры

// }Рарус adilas #Отчисление из спортивного учреждения -11632 2020.12.10

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли