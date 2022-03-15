#Область ОбработчикиСобытийРеквизитовФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Этап = Параметры.Этап;
	Организация = Параметры.Организация;
	ВидСпорта = Параметры.ВидСпорта;
	
	ЗаполнитьНастройкиПоВидамФизическойПодготовки();
	ЗаполнитьНормативыПоВидамФизическойПодготовки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандНаФорме

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаборНастройкиЭтаповПоОрганизациям();
	ЗаполнитьНаборОценкиПрохожденияНаЭтапПоОрганизациям();
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНаборНастройкиЭтаповПоОрганизациям();
	ЗаполнитьНаборОценкиПрохожденияНаЭтапПоОрганизациям();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовТабличныхЧастей

&НаКлиенте
Процедура РезультатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ТаблицаНормативов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если Найти(Элемент.Имя, "ПолЖ_") <> 0 Тогда
		Результат = ТекДанные["ПолЖ_" + Сред(Элемент.Имя, Найти(Элемент.Имя, "_") + 1)];
	Иначе
		Результат = ТекДанные["ПолМ_" + Сред(Элемент.Имя, Найти(Элемент.Имя, "_") + 1)];
	КонецЕсли;
	
	//{rarus lobash IN-19196 30.08.2021
	Если НЕ ТипНормативаБулево(ТекДанные.Норматив) Тогда
	//}rarus lobash IN-19196 30.08.2021
		ПараметрыФормы = Новый Структура("Норматив, Результат", ТекДанные.Норматив, Результат);
		Оповещение = Новый ОписаниеОповещения("РезультатНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ТекДанные, ИмяЭлемента", ТекДанные, Элемент.Имя));
		ОткрытьФорму("Документ.РезультатыСдачиКонтрольноПереводныхНормативов.Форма.ФормаВводаРезультата", 
		  ПараметрыФормы,
		  ЭтотОбъект,,,,
		  Оповещение,
		  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//{rarus lobash IN-19196 30.08.2021
	 КонецЕсли;
	 //}rarus lobash IN-19196 30.08.2021

КонецПроцедуры
  
&НаКлиенте
Процедура РезультатОчистка(Элемент, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ТаблицаНормативов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если Найти(Элемент.Имя, "ПолЖ_") <> 0 Тогда
		ТекДанные["ПолЧислоЖ_" + Сред(Элемент.Имя, Найти(Элемент.Имя, "_") + 1)] = 0;
	Иначе
		ТекДанные["ПолЧислоМ_" + Сред(Элемент.Имя, Найти(Элемент.Имя, "_") + 1)] = 0;
	КонецЕсли;
	
КонецПроцедуры  

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//{rarus lobash IN-19196 30.08.2021
&НаСервере
Функция  ТипНормативаБулево(Норматив)
	Возврат Норматив.ТипРезультата = Перечисления.ТипыРезультатов.Булево;	
КонецФункции
 //}rarus lobash IN-19196 30.08.2021

&НаКлиенте
Процедура РезультатНачалоВыбораЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если Результат.ТипРезультата = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Булево") Тогда
		Результат.РезультатЧисло = ?(ВРег(Результат.РезультатБулево) = "ИСТИНА", 1, 0);
	КонецЕсли;
		
	Если Найти(ДопПараметры.ИмяЭлемента, "ПолЖ_") <> 0 Тогда
		ДопПараметры.ТекДанные["ПолЖ_" + Сред(ДопПараметры.ИмяЭлемента, Найти(ДопПараметры.ИмяЭлемента, "_") + 1)] = Результат.Результат;
		ДопПараметры.ТекДанные["ПолЧислоЖ_" + Сред(ДопПараметры.ИмяЭлемента, Найти(ДопПараметры.ИмяЭлемента, "_") + 1)] = Результат.РезультатЧисло;
	Иначе
		ДопПараметры.ТекДанные["ПолМ_" + Сред(ДопПараметры.ИмяЭлемента, Найти(ДопПараметры.ИмяЭлемента, "_") + 1)] = Результат.Результат;
		ДопПараметры.ТекДанные["ПолЧислоМ_" + Сред(ДопПараметры.ИмяЭлемента, Найти(ДопПараметры.ИмяЭлемента, "_") + 1)] = Результат.РезультатЧисло;
	КонецЕсли; 
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаНормативовПолЖПриИзменении(Элемент)
	ТекДанные = Элементы.ТаблицаНормативов.ТекущиеДанные;
	Гуид =  Сред(Элемент.Имя,Найти(Элемент.Имя, "_")+1);
	Норматив = ТекДанные["Норматив"];
	
	ТекДанные["Выбор_" + Гуид] = Истина;
	
	ТипРезультатаНорматива = ПолучитьТипРезультата(ТекДанные["Норматив"]);
	Если ТипРезультатаНорматива = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Булево") Тогда
		ТекДанные["ПолЧислоЖ_" + Гуид] = ?(ВРег(ТекДанные["ПолЖ_" + Гуид]) = "ИСТИНА", 1, 0);
	ИначеЕсли ТипРезультатаНорматива = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Время") Тогда
		ТекДанные["ПолЧислоЖ_" + Гуид] = УчетСпортсменовОбщегоНазначенияКлиентСервер.ПересчитатьВремяИзСтрокиВМиллесекунды(ТекДанные["ПолЖ_" + Гуид]);		
	Иначе
		ТекДанные["ПолЧислоЖ_" + Гуид] = ТекДанные["ПолЖ_" + Гуид];
	КонецЕсли;
	
	ТекДанные["Выбор_" + Гуид] = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНормативовПолМПриИзменении(Элемент)
	ТекДанные = Элементы.ТаблицаНормативов.ТекущиеДанные;
	Гуид =  Сред(Элемент.Имя,Найти(Элемент.Имя, "_")+1);
	Норматив = ТекДанные["Норматив"];
	
	ТекДанные["Выбор_" + Гуид] = Истина;
	
	ТипРезультатаНорматива = ПолучитьТипРезультата(ТекДанные["Норматив"]);
	Если ТипРезультатаНорматива = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Булево") Тогда
		ТекДанные["ПолЧислоМ_" + Гуид] = ?(ВРег(ТекДанные["ПолМ_" + Гуид]) = "ИСТИНА", 1, 0);
	ИначеЕсли ТипРезультатаНорматива = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Время") Тогда
		ТекДанные["ПолЧислоМ_" + Гуид] = УчетСпортсменовОбщегоНазначенияКлиентСервер.ПересчитатьВремяИзСтрокиВМиллесекунды(ТекДанные["ПолМ_" + Гуид]);		
	Иначе
		ТекДанные["ПолЧислоМ_" + Гуид] = ТекДанные["ПолМ_" + Гуид];
	КонецЕсли;
	
	ТекДанные["Выбор_" + Гуид] = Истина;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТипРезультата(Норматив)
	Возврат Норматив.ТипРезультата;
КонецФункции

#Область ВидыФизическойПодготовки

&НаСервере
Процедура ЗаполнитьНастройкиПоВидамФизическойПодготовки()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Этап", Этап);
	Запрос.УстановитьПараметр("ВидСпорта", ВидСпорта);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВидФизическойПодготовки.Ссылка КАК Ссылка
	               |ПОМЕСТИТЬ ВТ_ВидыФизПодготовки
	               |ИЗ
	               |	Перечисление.ВидФизическойПодготовки КАК ВидФизическойПодготовки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ВТ_ВидыФизПодготовки.Ссылка КАК ВидФизическойПодготовки,
	               |	НастройкиЭтаповПоОрганизациям.ИтоговыйБалл КАК ПолМ,
	               |	0 КАК ПолЖ
	               |ПОМЕСТИТЬ ВТ_ИтоговыеБаллыДляПеревода
	               |ИЗ
	               |	ВТ_ВидыФизПодготовки КАК ВТ_ВидыФизПодготовки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиЭтаповПоОрганизациям.СрезПоследних КАК НастройкиЭтаповПоОрганизациям
	               |		ПО ВТ_ВидыФизПодготовки.Ссылка = НастройкиЭтаповПоОрганизациям.ВидФизическойПодготовки
	               |			И (НастройкиЭтаповПоОрганизациям.Этап = &Этап)
	               |			И (НастройкиЭтаповПоОрганизациям.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской))
	               |			И (НастройкиЭтаповПоОрганизациям.Организация = &Организация)
	               |			И (НастройкиЭтаповПоОрганизациям.ВидСпорта = &ВидСпорта)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ВТ_ВидыФизПодготовки.Ссылка,
	               |	0,
	               |	НастройкиЭтаповПоОрганизациям.ИтоговыйБалл
	               |ИЗ
	               |	ВТ_ВидыФизПодготовки КАК ВТ_ВидыФизПодготовки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиЭтаповПоОрганизациям.СрезПоследних КАК НастройкиЭтаповПоОрганизациям
	               |		ПО ВТ_ВидыФизПодготовки.Ссылка = НастройкиЭтаповПоОрганизациям.ВидФизическойПодготовки
	               |			И (НастройкиЭтаповПоОрганизациям.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский))
	               |			И (НастройкиЭтаповПоОрганизациям.Этап = &Этап)
	               |			И (НастройкиЭтаповПоОрганизациям.Организация = &Организация)
	               |			И (НастройкиЭтаповПоОрганизациям.ВидСпорта = &ВидСпорта)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ИтоговыеБаллыДляПеревода.ВидФизическойПодготовки КАК ВидФизическойПодготовки,
	               |	СУММА(ВТ_ИтоговыеБаллыДляПеревода.ПолМ) КАК ПолМ,
	               |	СУММА(ВТ_ИтоговыеБаллыДляПеревода.ПолЖ) КАК ПолЖ
	               |ИЗ
	               |	ВТ_ИтоговыеБаллыДляПеревода КАК ВТ_ИтоговыеБаллыДляПеревода
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТ_ИтоговыеБаллыДляПеревода.ВидФизическойПодготовки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	НастройкиЭтаповПоОрганизациям.Период КАК ЗаписьДействуетС,
	               |	НастройкиЭтаповПоОрганизациям.МинимальныйВозраст КАК МинимальныйВозраст
	               |ИЗ
	               |	РегистрСведений.НастройкиЭтаповПоОрганизациям.СрезПоследних КАК НастройкиЭтаповПоОрганизациям
	               |ГДЕ
	               |	НастройкиЭтаповПоОрганизациям.Организация = &Организация
	               |	И НастройкиЭтаповПоОрганизациям.ВидСпорта = &ВидСпорта
	               |	И НастройкиЭтаповПоОрганизациям.Этап = &Этап
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НастройкиЭтаповПоОрганизациям.Период,
	               |	НастройкиЭтаповПоОрганизациям.МинимальныйВозраст";
	Пакет = Запрос.ВыполнитьПакет();
	
	Выборка = Пакет[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаДанных = ТаблицаИтоговыхБалловНаФорме.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДанных, Выборка);
		
		строкаВидовФП = ТаблицаВидовФПНаФорме.Добавить();
		ЗаполнитьЗначенияСвойств(строкаВидовФП, Выборка);
		строкаВидовФП.УникальныйИдентификатор = СтрЗаменить(СокрЛП(Новый УникальныйИдентификатор()),"-","");
		
	КонецЦикла;
	
	НовыеРеквизиты = Новый Массив;
	массивТипов = Новый Массив;
	массивТипов.Добавить(Тип("Число"));
	массивТипов.Добавить(Тип("Строка"));
	
	Для Каждого строкаВидовФП Из ТаблицаВидовФПНаФорме Цикл
		
		гуид = строкаВидовФП.УникальныйИдентификатор;
		
		НовыеРеквизиты.Добавить(Новый РеквизитФормы("ПолЖ_" + гуид                      , Новый ОписаниеТипов(массивТипов)  , "ТаблицаНормативов"      , "Ж" , Истина));
		НовыеРеквизиты.Добавить(Новый РеквизитФормы("ПолМ_" + гуид                      , Новый ОписаниеТипов(массивТипов)  , "ТаблицаНормативов"      , "М" , Истина));
		
		НовыеРеквизиты.Добавить(Новый РеквизитФормы("БаллЖ_" + гуид                      , Новый ОписаниеТипов("Число")  , "ТаблицаНормативов"      , "Баллы (Ж)" , Истина));
		НовыеРеквизиты.Добавить(Новый РеквизитФормы("БаллМ_" + гуид                      , Новый ОписаниеТипов("Число")  , "ТаблицаНормативов"      , "Баллы (М)" , Истина));
		
		НовыеРеквизиты.Добавить(Новый РеквизитФормы("ПолЧислоЖ_" + гуид                 , Новый ОписаниеТипов("Число")   , "ТаблицаНормативов"      , "Ж"  , Истина));
		НовыеРеквизиты.Добавить(Новый РеквизитФормы("ПолЧислоМ_" + гуид                 , Новый ОписаниеТипов("Число")   , "ТаблицаНормативов"      , "М"  , Истина));
		
		НовыеРеквизиты.Добавить(Новый РеквизитФормы("Выбор_" + гуид                     , Новый ОписаниеТипов("Булево")  , "ТаблицаНормативов"      , "Используется"  , Истина));
		
	КонецЦикла;
	
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	Для Каждого строкаВидовФП Из ТаблицаВидовФПНаФорме Цикл
		ВыделятьЦветом = НЕ ВыделятьЦветом;
		
		гуид = строкаВидовФП.УникальныйИдентификатор;
		
		ГруппаВидФП                          = Элементы.Добавить("Группа" + гуид, Тип("ГруппаФормы"), Элементы.ГруппаВидФП);	
        ГруппаВидФП.Заголовок                = СокрЛП(строкаВидовФП.ВидФизическойПодготовки);
		ГруппаВидФП.ОтображатьВШапке         = Истина;
		ГруппаВидФП.Вид                      = ВидГруппыФормы.ГруппаКолонок;
		ГруппаВидФП.Группировка              = ГруппировкаКолонок.Горизонтальная;
		// {Рарус adilas #1.0.0.2 -Исправления по SonarQube 2021.04.23
		ГруппаВидФП.ШрифтЗаголовка           = ШрифтыСтиля.КрупныйШрифтТекста;
		// }Рарус adilas #1.0.0.2 -Исправления по SonarQube 2021.04.23
		
		НовыйЭлементВыбор                   = Элементы.Добавить("ТаблицаНормативовВыбор_" + гуид, Тип("ПолеФормы"), Элементы["Группа"+гуид]); 
        НовыйЭлементВыбор.Вид               = ВидПоляФормы.ПолеФлажка; 
        НовыйЭлементВыбор.ПутьКДанным       = "ТаблицаНормативов." + "Выбор_" + гуид;
		НовыйЭлементВыбор.Заголовок         = "";
		
		НовыйЭлементПолЖ                   = Элементы.Добавить("ТаблицаНормативовПолЖ_" + гуид, Тип("ПолеФормы"), Элементы["Группа"+гуид]); 
        НовыйЭлементПолЖ.Вид               = ВидПоляФормы.ПолеВвода;
        НовыйЭлементПолЖ.ПутьКДанным       = "ТаблицаНормативов." + "ПолЖ_" + гуид;
		НовыйЭлементПолЖ.РедактированиеТекста = Истина;
		НовыйЭлементПолЖ.КнопкаОчистки     = Истина;
		НовыйЭлементПолЖ.КнопкаВыбора      = Ложь;
		НовыйЭлементПолЖ.УстановитьДействие("НачалоВыбора", "РезультатНачалоВыбора");
		НовыйЭлементПолЖ.УстановитьДействие("ПриИзменении", "ТаблицаНормативовПолЖПриИзменении");
		НовыйЭлементПолЖ.УстановитьДействие("Очистка", "РезультатОчистка");
		
		НовыйЭлементБаллыЖ                 = Элементы.Добавить("ТаблицаНормативовБаллЖ_" + гуид, Тип("ПолеФормы"), Элементы["Группа"+гуид]); 
        НовыйЭлементБаллыЖ.Вид               = ВидПоляФормы.ПолеВвода; 
        НовыйЭлементБаллыЖ.ПутьКДанным       = "ТаблицаНормативов." + "БаллЖ_" + гуид;
				
		НовыйЭлементПолМ                   = Элементы.Добавить("ТаблицаНормативовПолМ_" + гуид, Тип("ПолеФормы"), Элементы["Группа"+гуид]); 
        НовыйЭлементПолМ.Вид               = ВидПоляФормы.ПолеВвода; 
        НовыйЭлементПолМ.ПутьКДанным       = "ТаблицаНормативов." + "ПолМ_" + гуид;
		НовыйЭлементПолМ.РедактированиеТекста = Истина;
		НовыйЭлементПолМ.КнопкаОчистки     = Истина;
		НовыйЭлементПолМ.КнопкаВыбора      = Ложь;
		НовыйЭлементПолМ.УстановитьДействие("НачалоВыбора", "РезультатНачалоВыбора");
		НовыйЭлементПолМ.УстановитьДействие("ПриИзменении", "ТаблицаНормативовПолМПриИзменении");
		НовыйЭлементПолЖ.УстановитьДействие("Очистка", "РезультатОчистка");
		
		НовыйЭлементБаллыМ                 = Элементы.Добавить("ТаблицаНормативовБаллМ_" + гуид, Тип("ПолеФормы"), Элементы["Группа"+гуид]); 
        НовыйЭлементБаллыМ.Вид               = ВидПоляФормы.ПолеВвода; 
        НовыйЭлементБаллыМ.ПутьКДанным       = "ТаблицаНормативов." + "БаллМ_" + гуид;
		
		НовыйЭлементПолЧислоЖ              = Элементы.Добавить("ТаблицаНормативовПолЧислоЖ_" + гуид, Тип("ПолеФормы"), Элементы["Группа"+гуид]); 
        НовыйЭлементПолЧислоЖ.Вид          = ВидПоляФормы.ПолеВвода; 
        НовыйЭлементПолЧислоЖ.ПутьКДанным  = "ТаблицаНормативов." + "ПолЧислоЖ_" + гуид;
		НовыйЭлементПолЧислоЖ.Видимость    = Ложь;
				
		НовыйЭлементПолЧислоМ              = Элементы.Добавить("ТаблицаНормативовПолЧислоМ_" + гуид, Тип("ПолеФормы"), Элементы["Группа"+гуид]); 
        НовыйЭлементПолЧислоМ.Вид          = ВидПоляФормы.ПолеВвода; 
        НовыйЭлементПолЧислоМ.ПутьКДанным  = "ТаблицаНормативов." + "ПолЧислоМ_" + гуид;
		НовыйЭлементПолЧислоМ.Видимость    = Ложь;
		
		Если ВыделятьЦветом Тогда
			// {Рарус adilas #1.0.0.2 -Исправления по SonarQube 2021.04.23
			НовыйЭлементПолЖ.ЦветФонаЗаголовка    	= ЦветаСтиля.НедоступныеДанныеЦвет;
			НовыйЭлементПолЖ.ЦветФона             	= ЦветаСтиля.НедоступныеДанныеЦвет;
			НовыйЭлементБаллыЖ.ЦветФонаЗаголовка    = ЦветаСтиля.НедоступныеДанныеЦвет;
			НовыйЭлементБаллыЖ.ЦветФона             = ЦветаСтиля.НедоступныеДанныеЦвет;
			
			НовыйЭлементПолМ.ЦветФонаЗаголовка    	= ЦветаСтиля.НедоступныеДанныеЦвет;
			НовыйЭлементПолМ.ЦветФона             	= ЦветаСтиля.НедоступныеДанныеЦвет;
			НовыйЭлементБаллыМ.ЦветФонаЗаголовка    = ЦветаСтиля.НедоступныеДанныеЦвет;
			НовыйЭлементБаллыМ.ЦветФона             = ЦветаСтиля.НедоступныеДанныеЦвет;
			// }Рарус adilas #1.0.0.2 -Исправления по SonarQube 2021.04.23
		КонецЕсли;
		
	КонецЦикла;	
	
	тзОсновнаяЗапись = Пакет[3].Выгрузить();
	Если тзОсновнаяЗапись.Количество() <> 0 Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,тзОсновнаяЗапись[0]);
	Иначе
		// {Рарус adilas #1.0.0.2 -Исправления по SonarQube 2021.04.23
		ЗаписьДействуетС = ТекущаяДатаСеанса();
		// }Рарус adilas #1.0.0.2 -Исправления по SonarQube 2021.04.23
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНормативыПоВидамФизическойПодготовки()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаВидопФП", ТаблицаВидовФПНаФорме.Выгрузить());
	Запрос.УстановитьПараметр("Этап", Этап);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидСпорта", ВидСпорта);
	
	ТекстОбщий = "";
	// {Рарус adilas #- -Sonar 2021.06.29
	УчетСпортсменовВызовСервера.ВвестиСтруктуруВоВременнуюТаблицу(
		  ТекстОбщий,
		  Новый Структура("ВидФизическойПодготовки,УникальныйИдентификатор"),
		  "ВТ_ФП",
		  "ТаблицаВидопФП");
	
	Запрос.Текст = ТекстОбщий +"
	                |;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	ВЫРАЗИТЬ(ВТ_ФП.УникальныйИдентификатор КАК СТРОКА(36)) КАК Гуид,
					|	ОценкиПрохожденияНаЭтап.Норматив КАК Норматив,
					|	ОценкиПрохожденияНаЭтап.Пол КАК Пол,
					|	ОценкиПрохожденияНаЭтап.Используется КАК Используется,
					|	ОценкиПрохожденияНаЭтап.РезультатЧисло КАК РезультатЧислоЖ,
					|	ОценкиПрохожденияНаЭтап.Баллы КАК БаллыЖ,
					|	0 КАК РезультатЧислоМ,
					|	0 КАК БаллыМ,
					|	ОценкиПрохожденияНаЭтап.ИдентификаторСтроки КАК ИдентификаторСтроки
					|ПОМЕСТИТЬ ВТ_ДанныеПОРС
					|ИЗ
					|	ВТ_ФП КАК ВТ_ФП
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОценкиПрохожденияНаЭтап.СрезПоследних(
					|				,
					|				Организация = &Организация
					|					И ВидСпорта = &ВидСпорта
					|					И Этап = &Этап) КАК ОценкиПрохожденияНаЭтап
					|		ПО ВТ_ФП.ВидФизическойПодготовки = ОценкиПрохожденияНаЭтап.ВидФизическойПодготовки
					|			И (ОценкиПрохожденияНаЭтап.Пол = ЗНАЧЕНИЕ(перечисление.ПолФизическогоЛица.женский))
					|
					|ОБЪЕДИНИТЬ ВСЕ
					|
					|ВЫБРАТЬ
					|	ВЫРАЗИТЬ(ВТ_ФП.УникальныйИдентификатор КАК СТРОКА(36)),
					|	ОценкиПрохожденияНаЭтап.Норматив,
					|	ОценкиПрохожденияНаЭтап.Пол,
					|	ОценкиПрохожденияНаЭтап.Используется,
					|	0,
					|	0,
					|	ОценкиПрохожденияНаЭтап.РезультатЧисло,
					|	ОценкиПрохожденияНаЭтап.Баллы,
					|	ОценкиПрохожденияНаЭтап.ИдентификаторСтроки КАК ИдентификаторСтроки
					|ИЗ
					|	ВТ_ФП КАК ВТ_ФП
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОценкиПрохожденияНаЭтап.СрезПоследних(
					|				,
					|				Организация = &Организация
					|					И ВидСпорта = &ВидСпорта
					|					И Этап = &Этап 
					|					И не ИдентификаторСтроки = """") КАК ОценкиПрохожденияНаЭтап
					|		ПО ВТ_ФП.ВидФизическойПодготовки = ОценкиПрохожденияНаЭтап.ВидФизическойПодготовки
					|			И (ОценкиПрохожденияНаЭтап.Пол = ЗНАЧЕНИЕ(перечисление.ПолФизическогоЛица.мужской))
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВТ_ДанныеПОРС.Гуид КАК Гуид,
					|	ВТ_ДанныеПОРС.Норматив КАК Норматив,
					|	ВТ_ДанныеПОРС.Норматив.ТипРезультата КАК ТипРезультата,
					|	ВТ_ДанныеПОРС.ИдентификаторСтроки КАК ИдентификаторСтроки,
					|	МАКСИМУМ(ВТ_ДанныеПОРС.Используется) КАК Используется,
					|	СУММА(ВТ_ДанныеПОРС.РезультатЧислоЖ) КАК РезультатЧислоЖ,
					|	СУММА(ВТ_ДанныеПОРС.БаллыЖ) КАК БаллыЖ,
					|	СУММА(ВТ_ДанныеПОРС.РезультатЧислоМ) КАК РезультатЧислоМ,
					|	СУММА(ВТ_ДанныеПОРС.БаллыМ) КАК БаллыМ
					|ИЗ
					|	ВТ_ДанныеПОРС КАК ВТ_ДанныеПОРС
					|
					|СГРУППИРОВАТЬ ПО
					|	ВТ_ДанныеПОРС.Гуид,
					|	ВТ_ДанныеПОРС.ИдентификаторСтроки,
					|	ВТ_ДанныеПОРС.Норматив
					|ИТОГИ
					|   ПО Норматив, ИдентификаторСтроки";
	
	ВыборкаНорматив = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНорматив.Следующий() Цикл
		
		ВыборкаИдентификатор = ВыборкаНорматив.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаИдентификатор.Следующий() Цикл 
			СтрокаНорматив = ТаблицаНормативов.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНорматив, ВыборкаНорматив);
			ЗаполнитьЗначенияСвойств(СтрокаНорматив, ВыборкаИдентификатор);
			Выборка = ВыборкаИдентификатор.Выбрать();
			
			Пока Выборка.Следующий() Цикл

				СтрокаНорматив["Выбор_" + Выборка.Гуид] = Выборка.Используется;
				СтрокаНорматив["ПолЧислоЖ_" + Выборка.Гуид] = Выборка.РезультатЧислоЖ;
				СтрокаНорматив["ПолЧислоМ_" + Выборка.Гуид] = Выборка.РезультатЧислоМ;
				СтрокаНорматив["БаллЖ_" + Выборка.Гуид] = Выборка.БаллыЖ;
				СтрокаНорматив["БаллМ_" + Выборка.Гуид] = Выборка.БаллыМ;
				Если Выборка.ТипРезультата = Перечисления.ТипыРезультатов.Время Тогда
					СтрокаНорматив["ПолЖ_" + Выборка.Гуид] = УчетСпортсменовОбщегоНазначенияКлиентСервер.ПересчитатьВремяВМиллесекундахВСтроку(Выборка.РезультатЧислоЖ);
					СтрокаНорматив["ПолМ_" + Выборка.Гуид] = УчетСпортсменовОбщегоНазначенияКлиентСервер.ПересчитатьВремяВМиллесекундахВСтроку(Выборка.РезультатЧислоМ);
				ИначеЕсли Выборка.ТипРезультата = Перечисления.ТипыРезультатов.Булево Тогда
					СтрокаНорматив["ПолЖ_" + Выборка.Гуид] = ?(Выборка.РезультатЧислоЖ = 1, "Сдал", "Не сдал");
					СтрокаНорматив["ПолМ_" + Выборка.Гуид] = ?(Выборка.РезультатЧислоМ = 1, "Сдал", "Не сдал");
				Иначе
					СтрокаНорматив["ПолЖ_" + Выборка.Гуид] = Выборка.РезультатЧислоЖ;
					СтрокаНорматив["ПолМ_" + Выборка.Гуид] = Выборка.РезультатЧислоМ;
				КонецЕсли;	
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьНаборДанныхВРегистрыСведений

&НаСервере
Процедура ЗаписатьНаборНастройкиЭтаповПоОрганизациям()
	
	Для Каждого строкаИтоговыеБаллы Из ТаблицаИтоговыхБалловНаФорме Цикл
		
		УстановитьНаборЗаписейПоПолуНастройкиЭтапов(строкаИтоговыеБаллы, Перечисления.ПолФизическогоЛица.Женский);
		УстановитьНаборЗаписейПоПолуНастройкиЭтапов(строкаИтоговыеБаллы, Перечисления.ПолФизическогоЛица.Мужской);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНаборЗаписейПоПолуНастройкиЭтапов(строкаИтоговыеБаллы, Пол)
	
	НаборЗаписей = РегистрыСведений.НастройкиЭтаповПоОрганизациям.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.ВидСпорта.Установить(ВидСпорта);
	НаборЗаписей.Отбор.Этап.Установить(Этап);
	НаборЗаписей.Отбор.ВидФизическойПодготовки.Установить(строкаИтоговыеБаллы.ВидФизическойПодготовки);
	НаборЗаписей.Отбор.Пол.Установить(Пол);
	НаборЗаписей.Прочитать();
	
	ПериодНайден = Ложь;
	Для Каждого Запись_ Из НаборЗаписей Цикл
		Если Запись_.Период = ЗаписьДействуетС Тогда
			ПериодНайден = Истина;
			Запись_.МинимальныйВозраст = МинимальныйВозраст;
			Запись_.ИтоговыйБалл = ?(Пол = Перечисления.ПолФизическогоЛица.Мужской, строкаИтоговыеБаллы.ПолМ, строкаИтоговыеБаллы.ПолЖ);  
		КонецЕсли;	
	КонецЦикла;
	
	Если НЕ ПериодНайден Тогда
		Запись_ = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись_, ЭтотОбъект);
		Запись_.ВидФизическойПодготовки = строкаИтоговыеБаллы.ВидФизическойПодготовки;
		Запись_.Период = ЗаписьДействуетС;
		Запись_.Пол = Пол;
		Запись_.ИтоговыйБалл = ?(Пол = Перечисления.ПолФизическогоЛица.Мужской, строкаИтоговыеБаллы.ПолМ, строкаИтоговыеБаллы.ПолЖ);
	КонецЕсли;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ЗаписьЖурналаРегистрации("Данные.Изменение", 
           УровеньЖурналаРегистрации.Ошибка,
           Метаданные.РегистрыСведений.НастройкиЭтаповПоОрганизациям,
           НаборЗаписей,
           "Не удалось записать набор Организация: """ + Организация + """ вид спорта: """ + ВидСпорта + """ Этап: """ + Этап + """ Вид физ.подготовки: """ + строкаИтоговыеБаллы.ВидФизическойПодготовки + """ Пол: """ + пол);
	КонецПопытки;	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьНаборОценкиПрохожденияНаЭтапПоОрганизациям()
	
	ЖенскийПол = Перечисления.ПолФизическогоЛица.Женский;
	МужскойПол = Перечисления.ПолФизическогоЛица.Мужской;
	
	Для Каждого СтрокаВидФП Из ТаблицаВидовФПНаФорме Цикл
		
		Гуид = СтрокаВидФП.УникальныйИдентификатор;
		
		Для Каждого СтрокаНорматив Из ТаблицаНормативов Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаНорматив.ИдентификаторСтроки) Тогда
				СтрокаНорматив.ИдентификаторСтроки = Новый УникальныйИдентификатор;
			КонецЕсли;
			
			УстановитьНаборЗаписейОценкиПрохожденияНаЭтап(
			   СтрокаВидФП.ВидФизическойПодготовки, 
			   ЖенскийПол,
			   СтрокаНорматив["Выбор_" + Гуид],
			   СтрокаНорматив["ПолЧислоЖ_" + Гуид],
			   СтрокаНорматив["БаллЖ_" + Гуид],
			   СтрокаНорматив.Норматив,
			   СтрокаНорматив.ИдентификаторСтроки);
			   
			УстановитьНаборЗаписейОценкиПрохожденияНаЭтап(
			   СтрокаВидФП.ВидФизическойПодготовки, 
			   МужскойПол,
			   СтрокаНорматив["Выбор_" + Гуид],
			   СтрокаНорматив["ПолЧислоМ_" + Гуид],
			   СтрокаНорматив["БаллМ_" + Гуид],
			   СтрокаНорматив.Норматив,
			   СтрокаНорматив.ИдентификаторСтроки);   
			
		КонецЦикла;	
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНаборЗаписейОценкиПрохожденияНаЭтап(ВидФизическойПодготовки, Пол, Используется, РезультатЧисло, Баллы, Норматив, ИдентификаторСтроки)
	
	НаборЗаписей = РегистрыСведений.ОценкиПрохожденияНаЭтап.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.ВидСпорта.Установить(ВидСпорта);
	НаборЗаписей.Отбор.Этап.Установить(Этап);
	НаборЗаписей.Отбор.Норматив.Установить(Норматив);
	НаборЗаписей.Отбор.Используется.Установить(Используется);
	НаборЗаписей.Отбор.ВидФизическойПодготовки.Установить(ВидФизическойПодготовки);
	НаборЗаписей.Отбор.Пол.Установить(Пол);
	НаборЗаписей.Отбор.ИдентификаторСтроки.Установить(ИдентификаторСтроки);
	НаборЗаписей.Прочитать();
	
	ПериодНайден = Ложь;
	Для Каждого Запись_ Из НаборЗаписей Цикл
		Если Запись_.Период = ЗаписьДействуетС Тогда
			ПериодНайден = Истина;
			Запись_.РезультатЧисло = РезультатЧисло;
			Запись_.Баллы = Баллы;  
		КонецЕсли;	
	КонецЦикла;
	
	Если НЕ ПериодНайден Тогда
		Запись_ = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись_, ЭтотОбъект);
		Запись_.ВидФизическойПодготовки = ВидФизическойПодготовки;
		Запись_.Норматив = Норматив;
		Запись_.Используется = Используется;
		Запись_.Период = ЗаписьДействуетС;
		Запись_.Пол = Пол;
		Запись_.РезультатЧисло = РезультатЧисло;
		Запись_.Баллы = Баллы;
		Запись_.ИдентификаторСтроки = ИдентификаторСтроки;
	КонецЕсли;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ЗаписьЖурналаРегистрации("Данные.Изменение", 
           УровеньЖурналаРегистрации.Ошибка,
           Метаданные.РегистрыСведений.ОценкиПрохожденияНаЭтап,
           НаборЗаписей,
           "Не удалось записать набор Организация: """ + Организация + """ вид спорта: """ + ВидСпорта + """ Этап: """ + Этап + """ Вид физ.подготовки: """ + ВидФизическойПодготовки + """ Пол: """ + пол + """ Норматив: """ + Норматив);
	КонецПопытки;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаНормативовНормативПриИзменении(Элемент)
	ТекДанные = Элементы.ТаблицаНормативов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	ТаблицаНормативовНормативПриИзмененииНаСервере(ТекДанные.Норматив);
КонецПроцедуры

&НаСервере
Процедура ТаблицаНормативовНормативПриИзмененииНаСервере(Норматив)
	СписокВыбора = Ложь;
	Маска = Неопределено;
	ВыбиратьТип = Неопределено;
	
	ТипРезультата = ПолучитьТипРезультата(Норматив);
	Если ТипРезультата <> Неопределено Тогда
		Если ТипРезультата = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Булево") Тогда
			Вид = ВидПоляФормы.ПолеВвода;
			СписокВыбора = истина;
		ИначеЕсли ТипРезультата = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Время") Тогда
			Вид = ВидПоляФормы.ПолеВвода;
			Маска = "99:99:99:999";
			ВыбиратьТип = Ложь;
		ИначеЕсли ТипРезультата = ПредопределенноеЗначение("Перечисление.ТипыРезультатов.Число") Тогда
			Вид = ВидПоляФормы.ПолеВвода;
			ВыбиратьТип = Ложь;
		КонецЕсли;
	КонецЕсли;

	Для каждого ВидФП из ТаблицаВидовФПНаФорме Цикл 
		Гуид  = ВидФП.УникальныйИдентификатор;
		
		Элементы["ТаблицаНормативовПолЖ_" + Гуид].Вид = Вид;
		Элементы["ТаблицаНормативовПолМ_" + Гуид].Вид = Вид;
		Если СписокВыбора Тогда
			Элементы["ТаблицаНормативовПолЖ_" + Гуид].РежимВыбораИзСписка = Истина;
			Элементы["ТаблицаНормативовПолЖ_" + Гуид].СписокВыбора.Добавить("Сдал");
			Элементы["ТаблицаНормативовПолЖ_" + Гуид].СписокВыбора.Добавить("Не сдал");
			Элементы["ТаблицаНормативовПолЖ_" + Гуид].СписокВыбора.Добавить("");
			Элементы["ТаблицаНормативовПолМ_" + Гуид].РежимВыбораИзСписка = Истина;
			Элементы["ТаблицаНормативовПолМ_" + Гуид].СписокВыбора.Добавить("Сдал");
			Элементы["ТаблицаНормативовПолМ_" + Гуид].СписокВыбора.Добавить("Не сдал");
			Элементы["ТаблицаНормативовПолМ_" + Гуид].СписокВыбора.Добавить("");
		Иначе
			Элементы["ТаблицаНормативовПолЖ_" + Гуид].РежимВыбораИзСписка = Ложь;
			Элементы["ТаблицаНормативовПолМ_" + Гуид].РежимВыбораИзСписка = Ложь;
		КонецЕсли;	

		Если Маска <> Неопределено Тогда
			Элементы["ТаблицаНормативовПолЖ_" + Гуид].Маска = Маска;
			Элементы["ТаблицаНормативовПолМ_" + Гуид].Маска = Маска;
			//{rarus lobash IN-19196 30.08.2021
			СтрокиНорматива = ТаблицаНормативов.НайтиСтроки(Новый Структура("Норматив", Норматив));
			Для Каждого Стр из СтрокиНорматива Цикл
				Если Стр["ПолЖ_" + Гуид] = 0 Тогда
					Стр["ПолЖ_" + Гуид] = Строка("");
				КонецЕсли;
				Если Стр["ПолМ_" + Гуид] = 0 Тогда
					Стр["ПолМ_" + Гуид] = Строка("");
				КонецЕсли;
			КонецЦикла;
			//}rarus lobash IN-19196 30.08.2021
		КонецЕсли;
		Если ВыбиратьТип <> Неопределено Тогда
			Элементы["ТаблицаНормативовПолЖ_" + Гуид].ВыбиратьТип = ВыбиратьТип;
			Элементы["ТаблицаНормативовПолМ_" + Гуид].ВыбиратьТип = ВыбиратьТип;
		КонецЕсли;

	КонецЦикла;
КонецПроцедуры
#КонецОбласти

#КонецОбласти











