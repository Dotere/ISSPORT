
// {Рарус adilas #Электронный журнал посещений -16226 2021.05.20
#Область ПрограммныйИнтерфейс

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет заполнение реквизитов переданного объекта по заданным правилам.
// Формирует и выводит сообщение у поля управляемой формы, связанного с реквизитом объекта.
// 
// Параметры:
//	ПроверяемаяФорма     - ФормаКлиентскогоПриложения - форма, заполнение реквизитов которой проверяется.
//	ПроверяемыеСвойства	 - СписокЗначений   - свойства, заполнение которых нужно проверить:
//  	* Значение      - Строка - путь к данным формы, 
//		* Представление - Строка - сообщение об ошибке, если свойство не заполнено.
//	Сообщатель           - ОбщийМодуль - Модуль, выводящий сообщение.
//                                       Если не указан, сообщения выводиться не будут.
//                                       Модуль должен содержать процедуру СообщитьПользователю. 
//                                       (См. ОбщегоНазначения.СообщитьПользователю).
//
// Возвращаемое значение:
//	Булево - Истина, если все свойства заполнены, Ложь - в противном случае. 
//			
Функция СвойстваФормыЗаполнены(ПроверяемаяФорма, ПроверяемыеСвойства, Сообщатель = Неопределено) Экспорт
	
	НезаполненныеСвойства = Новый Массив;
	
	Для Каждого ПроверяемоеСвойство Из ПроверяемыеСвойства Цикл
		Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(ПроверяемаяФорма, ПроверяемоеСвойство.Значение);
		Если НЕ ЗначениеЗаполнено(Значение) Тогда
			НезаполненныеСвойства.Добавить(ПроверяемоеСвойство);
		КонецЕсли;
	КонецЦикла;
	
	Если Сообщатель <> Неопределено Тогда
		Для Каждого НезаполненноеСвойство Из НезаполненныеСвойства Цикл 
			Сообщатель.СообщитьПользователю(
				НезаполненноеСвойство.Представление, , 
				НезаполненноеСвойство.Значение);
		КонецЦикла
	КонецЕсли;
	
	Возврат НезаполненныеСвойства.Количество() = 0;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Универсальный механизм "Месяц строкой".

// Заполняет реквизит представлением месяца, хранящегося в другом реквизите.
//
// Параметры:
//		РедактируемыйОбъект
//		ПутьРеквизита - Строка, путь к реквизиту, содержащего дату.
//		ПутьРеквизитаПредставления - Строка, путь к реквизиту в который помещается представление месяца.
//
Процедура ЗаполнитьМесяцПоДате(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления) Экспорт
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, ПолучитьПредставлениеМесяца(Значение));
	
КонецПроцедуры

// Возвращает представление месяца по переданной дате.
//
// Параметры:
//		ДатаНачалаМесяца
//
// Возвращаемое значение;
//		Строка
//
Функция ПолучитьПредставлениеМесяца(ДатаНачалаМесяца) Экспорт
	
	Возврат Формат(ДатаНачалаМесяца, "ДФ='ММММ гггг'");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СортировкаВыбором(Знач Массив) Экспорт
    
    Мин = 0;
    Для i = 0 По Массив.ВГраница() Цикл        
        Мин = i;                               
        Для j = i + 1 ПО Массив.ВГраница() Цикл           
            Если Массив[j] < Массив[Мин] Тогда
                Мин = j;
            КонецЕсли; 
        КонецЦикла; 
        Если Массив [Мин] = Массив [i] Тогда           
            Продолжить;
        КонецЕсли;
        
        Смена = Массив[i];                            
        Массив[i] = Массив[Мин];
        Массив[Мин] = Смена;  
        
    КонецЦикла;
    Возврат Массив;    
КонецФункции

Функция ПересчитатьВремяВМиллесекундахВСтроку(РезультатЧисло)Экспорт
	Если Не РезультатЧисло = null Тогда
	количествочасов  = РезультатЧисло/3600000;
	остатокВМилСек   = Окр((количествочасов - Цел(количествочасов))*3600000);
	количествоМинут  = остатокВМилСек/60000;
	остатокВМилСек   = Окр((количествоМинут - Цел(количествоМинут))*60000);
	количествоСек    = остатокВМилСек/1000;
	остатокВМилСек   = Цел((количествоСек - Цел(количествоСек))*1000);
	
	Если остатокВМилСек = 999 Тогда
		количествоСек = количествоСек + 1;
		остатокВМилСек = 0;
	КонецЕсли;
	
	Если Цел(количествоСек) = 60 Тогда
		количествоМинут = количествоМинут + 1;
		количествоСек   = 0;
	КонецЕсли;
	
	Если Цел(количествоМинут) = 60 Тогда
		количествочасов = количествочасов + 1;
		количествоМинут = 0;
	КонецЕсли;	
	
	остатокВМилСекСтрока =  СокрЛП(остатокВМилСек);
	Пока СтрДлина(остатокВМилСекСтрока) < 3 Цикл
		остатокВМилСекСтрока = "0" + СокрЛП(остатокВМилСекСтрока);
	КонецЦикла;	
	
	Возврат ?(Цел(количествочасов)<10, "0"+СокрЛП(Цел(количествочасов)), СокрЛП(Цел(количествочасов)))+ ":" 
	  +?(Цел(количествоМинут)<10, "0"+СокрЛП(Цел(количествоМинут)), СокрЛП(Цел(количествоМинут)))
	  + ":" + ?(Цел(количествоСек)<10, "0" + СокрЛП(Цел(количествоСек)), СокрЛП(Цел(количествоСек))) + ":" + СокрЛП(остатокВМилСекСтрока);
  Иначе 
	  Возврат 0;
	КонецЕсли
КонецФункции

Функция ПроверитьРезультатСтроковыйПриИзменении(РезультатСтроковый, Отказ) Экспорт
	
	массивЗначений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(РезультатСтроковый,":");
	РезультатСтроковыйДубль = "";
	Для Индекс = 0 По массивЗначений.Количество()-1 Цикл
		значениеВремя = массивЗначений[Индекс];
		РезультатСтроковыйДубль = РезультатСтроковыйДубль + ?(значениеВремя = "", "00",значениеВремя);
		Если Индекс < 3 Тогда
			Если значениеВремя <> "" Тогда
				Если СтрокаВЧисло(значениеВремя) >59 Тогда
					Если Индекс = 0 Тогда
						 Параметр = "часа";
					 ИначеЕсли Индекс = 1 Тогда
						 Параметр = "минуты";
					 Иначе
						 Параметр = "секунды";
					 КонецЕсли;
					 
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			          НСтр("ru = 'Неверное значение %1!'"),
					  Параметр);
					  	  
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"РезультатСтроковый");
					Отказ = Истина;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Отказ
	
КонецФункции

Функция ПересчитатьВремяИзСтрокиВМиллесекунды(РезультатСтроковый)Экспорт
	
	массивЗначений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(РезультатСтроковый,":");
	ВремяВМилСек = 0;
	Для Индекс = 0 По массивЗначений.Количество()-1 Цикл
		значениеВремя = массивЗначений[Индекс];
		Если Индекс	= 0 И значениеВремя <> "" И значениеВремя <> "00" Тогда
			ВремяВМилСек = ВремяВМилСек + СтрокаВЧисло(значениеВремя) * 3600000;
		ИначеЕсли Индекс = 1 И значениеВремя <> "" И значениеВремя <> "00" Тогда
			ВремяВМилСек = ВремяВМилСек + СтрокаВЧисло(значениеВремя) * 60000;
		ИначеЕсли Индекс = 2 И значениеВремя <> "" И значениеВремя <> "00" Тогда
			ВремяВМилСек = ВремяВМилСек + СтрокаВЧисло(значениеВремя) * 1000;
		Иначе
			ВремяВМилСек = ВремяВМилСек + СтрокаВЧисло(значениеВремя);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат ВремяВМилСек;
	
КонецФункции

Функция СтрокаВЧисло(ЧислоСтрокой)
	
	Попытка
		Значение = Число(ЧислоСтрокой);
	Исключение
		Значение = 0;
	КонецПопытки;
	
	Возврат Значение
	
КонецФункции	

// {Рарус kotana #7847 2020.07.24
//
Процедура ПреобразоватьВТЗРекурсия(тДерево,тТаблица) Экспорт
	
	Для Каждого тСтр Из тДерево.Строки Цикл
		
		Если тСтр.Строки.Количество()>0 Тогда
			ПреобразоватьВТЗРекурсия(тСтр, тТаблица);
		Иначе
			
			нСтр = тТаблица.Добавить();
			
			ЗаполнитьЗначенияСвойств(нСтр,тСтр);

		КонецЕсли;			
				
	КонецЦикла;
	
КонецПроцедуры
// }Рарус kotana #7847 2020.07.24

#КонецОбласти

#КонецОбласти

// }Рарус adilas #Электронный журнал посещений -16226 2021.05.20