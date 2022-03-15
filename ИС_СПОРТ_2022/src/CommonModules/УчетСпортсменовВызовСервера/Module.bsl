
#Область УстановкаПараметровСеанса

Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	Обработчики.Вставить("ТекущаяОрганизация" , "УчетСпортсменовВызовСервера.УстановкаПараметровСеанса");
	Обработчики.Вставить("ТекущийТренер"      , "УчетСпортсменовВызовСервера.УстановкаПараметровСеанса");
		
КонецПроцедуры

Процедура УстановкаПараметровСеанса(Знач ИмяПараметра, УстановленныеПараметры) Экспорт
	
	Если ИмяПараметра <> "ТекущаяОрганизация" И
		   ИмяПараметра <> "ТекущийТренер" Тогда		
		    Возврат;
	КонецЕсли;
	
	Если РольДоступна("ПолныеПрава") Или РольДоступна("Руководитель") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РольДоступна("Тренер") И ИмяПараметра = "ТекущийТренер" Тогда
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИмяПараметра = "ТекущаяОрганизация" Тогда 
		
		Попытка
			Значение = ЗначенияПараметровСеансаТекущаяОрганизация();
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить параметр сеанса ТекущаяОрганизация по причине:
			|""%1"".
			|
			|Обратитесь к администратору.'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;
		
		Если ТипЗнч(Значение) = Тип("Строка") Тогда
			ВызватьИсключение Значение;
		КонецЕсли;
		
		ПараметрыСеанса.ТекущаяОрганизация         = Значение;
		
		УстановленныеПараметры.Добавить("ТекущаяОрганизация");
		
	Иначе
		
		Попытка
			Значение = ЗначенияПараметровСеансаТекущийТренер();
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить параметр сеанса ТекущийТренер по причине:
			|""%1"".
			|
			|Обратитесь к администратору.'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;
		
		Если ТипЗнч(Значение) = Тип("Строка") Тогда
			ВызватьИсключение Значение;
		КонецЕсли;
		
		ПараметрыСеанса.ТекущийТренер         = Значение;
		
		УстановленныеПараметры.Добавить("ТекущийТренер");
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЗначенияПараметровСеансаТекущаяОрганизация()
		
	ЗаголовокОшибки = НСтр("ru = 'Не удалось установить параметр сеанса ТекущаяОрганизация.'") + Символы.ПС;
	
	ОрганизацияНеНайдена = Ложь;
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СоответствияПользователейИОрганизаций.Организация КАК Организация
	               |ИЗ
	               |	РегистрСведений.СоответствияПользователейИОрганизаций КАК СоответствияПользователейИОрганизаций
	               |ГДЕ
	               |	СоответствияПользователейИОрганизаций.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	результат = Запрос.Выполнить();
	Если результат.Пустой() Тогда
		ОрганизацияНеНайдена = Истина;
	КонецЕсли;	
    
    // {Рарус kotana #IN-18238 -Недостаточно прав на просмотр карточки спортсмена 2021.07.14
    //Sonar: В тех случаях, где роль не дает никаких прав на объекты метаданных, 
    //используется только для определения или иного дополнительного права, следует использовать метод РольДоступна.
    Если РольДоступна("Руководитель") Тогда
        Возврат Справочники.Организации.ПустаяСсылка();
    КонецЕсли;
    // }Рарус kotana #IN-18238 -Недостаточно прав на просмотр карточки спортсмена 2021.07.14
    
	Если ОрганизацияНеНайдена Тогда
		
		Возврат ЗаголовокОшибки + "Не найдена организация для " + СокрЛП(ТекущийПользователь);
	КонецЕсли;
		
	Возврат результат.Выгрузить()[0].Организация;
	
КонецФункции

Функция ЗначенияПараметровСеансаТекущийТренер()
		
	ЗаголовокОшибки = НСтр("ru = 'Не удалось установить параметр сеанса ТекущийТренер.'") + Символы.ПС;
	
	ТренерНеНайден = Ложь;
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Тренеры.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Тренеры КАК Тренеры
	               |ГДЕ
	               |	Тренеры.ФизическоеЛицо = &ФизическоеЛицо";
	Запрос.УстановитьПараметр("ФизическоеЛицо", ТекущийПользователь.ФизическоеЛицо);
	результат = Запрос.Выполнить();
	Если результат.Пустой() Тогда
		ТренерНеНайден = Истина;
	КонецЕсли;	
	
	Если ТренерНеНайден Тогда
		
		Возврат ЗаголовокОшибки + "Не найдена запись по тренеру для " + СокрЛП(ТекущийПользователь);
	КонецЕсли;
		
	Возврат результат.Выгрузить()[0].Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СозданиеДинамическогоСписка(ЭтотОбъект, ИмяСписка, ТекстЗапроса = "",  МассивКолонок,	СписокДействий = Неопределено, ТаблицаСписка, ДобавитьВ = "", ВставитьПеред = "", СвояКоманднаяПанель = ЛОЖЬ, ПараметрыЗапроса = Неопределено) Экспорт
	
	Если ТекстЗапроса = "" И ТаблицаСписка = "" Тогда Сообщить("Ошибка формирования динамического списка, укажите запрос или таблицу"); Возврат; КонецЕсли;
	
	Форма = ЭтотОбъект.ЭтаФорма;
	
	Если СвояКоманднаяПанель Тогда
		Если ВставитьПеред = "" Тогда
			ГруппаДинамическогоСписка  = Форма.Элементы.Добавить("Группа" + ИмяСписка + "CоСвоейКоманднойПанелью",Тип("ГруппаФормы"),?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ]));
		Иначе
			ГруппаДинамическогоСписка  = Форма.Элементы.Вставить("Группа" + ИмяСписка + "CоСвоейКоманднойПанелью",Тип("ГруппаФормы"),?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ]),Форма.Элементы[ВставитьПеред]);			
		КонецЕсли;
		ГруппаДинамическогоСписка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаДинамическогоСписка.ОтображатьЗаголовок = Ложь;
		ГруппаДинамическогоСписка.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаДинамическогоСписка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		КоманднаяПанельСписка  = Форма.Элементы.Добавить(ИмяСписка + "КоманднаяПанель2",Тип("ГруппаФормы"),ГруппаДинамическогоСписка);
		КоманднаяПанельСписка.Вид = ВидГруппыФормы.КоманднаяПанель;			
	КонецЕсли;
									
	ТипыРеквизита = Новый Массив;                             
	ТипыРеквизита.Добавить(Тип("ДинамическийСписок"));
	ОписаниеТиповДляРеквизита = Новый ОписаниеТипов(ТипыРеквизита); 
	ДинамическийСписок = Новый РеквизитФормы(ИмяСписка, ОписаниеТиповДляРеквизита,,"",ЛОЖЬ); 
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(ДинамическийСписок);        
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);        
	РеквизитДинамическийСписок = Форма[ИмяСписка]; 
	Если ТекстЗапроса = "" Тогда
		РеквизитДинамическийСписок.ПроизвольныйЗапрос = ЛОЖЬ;
		РеквизитДинамическийСписок.ОсновнаяТаблица = ТаблицаСписка;
	Иначе
		РеквизитДинамическийСписок.ПроизвольныйЗапрос = ИСТИНА;
		РеквизитДинамическийСписок.ТекстЗапроса = ТекстЗапроса;
		Если ТаблицаСписка <> "" Тогда РеквизитДинамическийСписок.ОсновнаяТаблица = ТаблицаСписка; КонецЕсли;		
	КонецЕсли;
	
	Если ПараметрыЗапроса <> Неопределено Тогда
		Для Каждого Параметра из ПараметрыЗапроса Цикл
			РеквизитДинамическийСписок.Параметры.УстановитьЗначениеПараметра(Параметра.Ключ,Параметра.Значение);	
		КонецЦикла;		 
	КонецЕсли;
	
	Если ЛОЖЬ
		ИЛИ ВставитьПеред = "" 
		ИЛИ СвояКоманднаяПанель 
		Тогда
		ТаблицаФормы = Форма.Элементы.Добавить(ИмяСписка,Тип("ТаблицаФормы"),?(СвояКоманднаяПанель,ГруппаДинамическогоСписка,?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ])));
	Иначе
		ТаблицаФормы = Форма.Элементы.Вставить(ИмяСписка,Тип("ТаблицаФормы"),?(ДобавитьВ = "",Форма,Форма.Элементы[ДобавитьВ]),Форма.Элементы[ВставитьПеред]);	
	КонецЕсли;		
	ТаблицаФормы.ПутьКДанным = ИмяСписка;  
	
	Если СвояКоманднаяПанель Тогда
		Форма.Элементы[ИмяСписка].ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	КонецЕсли;

	Для Каждого Элемента Из МассивКолонок Цикл
		ПараметрыКолонки = СтрЗаменить(Элемента,",",Символы.ПС);
		Если СтрЧислоСтрок(ПараметрыКолонки) > 1 Тогда
			ЗаголовокСписка = СтрПолучитьСтроку(ПараметрыКолонки, 1);
			ИмяКолонки = СтрПолучитьСтроку(ПараметрыКолонки, 2);
		Иначе
			ЗаголовокСписка = "";
			ИмяКолонки = ПараметрыКолонки; 
		КонецЕсли;	
		НоваяКолонкаТаблицы = Форма.Элементы.Добавить(ИмяСписка + ИмяКолонки, Тип("ПолеФормы"), ТаблицаФормы);
		Если ЗаголовокСписка <> "" Тогда НоваяКолонкаТаблицы.Заголовок = ЗаголовокСписка; КонецЕсли;
		НоваяКолонкаТаблицы.ПутьКДанным = ИмяСписка + "." + ИмяКолонки; 	
	КонецЦикла;
	
	Если СписокДействий <> Неопределено Тогда 	
		ПереченьСвойств = "ПриИзменении
						|Выбор
						|ПриАктивизацииСтроки
						|ВыборЗначения
						|ПриАктивизацииПоля
						|ПриАктивизацииЯчейки
						|ПередНачаломДобавления
						|ПередНачаломИзменения
						|ПередУдалением
						|ПриНачалеРедактирования
						|ПередОкончаниемРедактирования
						|ПриОкончанииРедактирования
						|ОбработкаВыбора
						|ПередРазворачиванием
						|ПередСворачиванием
						|ПослеУдаления
						|ПриСменеТекущегоРодителя
						|ОбработкаЗаписиНового
						|ПриСохраненииПользовательскихНастроекНаСервере
						|ПередЗагрузкойПользовательскихНастроекНаСервере
						|ПриЗагрузкеПользовательскихНастроекНаСервере
						|ПриОбновленииСоставаПользовательскихНастроекНаСервере
						|ОбработкаЗапросаОбновления
						|ПриПолученииДанныхНаСервере
						|НачалоПеретаскивания
						|ПроверкаПеретаскивания
						|ОкончаниеПеретаскивания
						|Перетаскивание";
		Для Счетчик = 1 по 28 Цикл
			ИмяСвойства = СтрПолучитьСтроку(ПереченьСвойств, Счетчик);
			Форма.Элементы[ИмяСписка].УстановитьДействие(ИмяСвойства,?(СписокДействий.Свойство(ИмяСвойства),СписокДействий[ИмяСвойства],""));
		КонецЦикла;
	КонецЕсли;	

КонецПроцедуры

// {Рарус adilas #- -Sonar 2021.06.29

// {Рарус adilas #16864 -Спортсмен другого спорт. учреждения в сборной команде. 2021.06.02
Функция ТекущиеПараметрыФО(Организация = Неопределено) Экспорт
	// {Рарус adilas #22219 -Функциональные опции 2021.12.09
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиФОДляОрганизации.Организация КАК Организация,
		|	НастройкиФОДляОрганизации.ИспользоватьВозрастныеГруппы КАК ИспользоватьВозрастныеГруппы,
		|	НастройкиФОДляОрганизации.ИспользоватьСтрахованиеСпортсменов КАК ИспользоватьСтрахованиеСпортсменов
		|ИЗ
		|	РегистрСведений.НастройкиФОДляОрганизации КАК НастройкиФОДляОрганизации
		|ГДЕ
		|	НастройкиФОДляОрганизации.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", ?(РольДоступна("Методист"), ПараметрыСеанса.ТекущаяОрганизация, Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
		
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	// }Рарус adilas #22219 -Функциональные опции 2021.12.09
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
			ИспользоватьВГ = ВыборкаДетальныеЗаписи.ИспользоватьВозрастныеГруппы;
			ИспользоватьСтрахование = ВыборкаДетальныеЗаписи.ИспользоватьСтрахованиеСпортсменов; 
			
		КонецЦикла;
		
	Иначе
		
		ИспользоватьВГ = Ложь;
		ИспользоватьСтрахование = Ложь;
		
	КонецЕсли;
		
	ЗначенияФО = Новый Структура; 
	ЗначенияФО.Вставить("СтрахованиеСпортсменовОрганизация", ИспользоватьСтрахование);
	ЗначенияФО.Вставить("ВозрастныеГруппыОрганизация", ИспользоватьВГ);

	Возврат ЗначенияФО;
	
КонецФункции
// }Рарус adilas #16864 -Спортсмен другого спорт. учреждения в сборной команде. 2021.06.02

// {Рарус adilas #22219 -Функциональные опции 2021.11.09
Функция ТекущаяОрганизация() Экспорт

	Возврат ПараметрыСеанса.ТекущаяОрганизация;
	
КонецФункции
// }Рарус adilas #22219 -Функциональные опции 2021.11.09
// {Рарус dotere #22114 -Автоматические напоминания используются или нет 2021.11.12
Функция ТекущаяОрганизацияНапоминания() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.АвтоматическиеНапоминанияПользователям КАК АвтоматическиеНапоминанияПользователям
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ПараметрыСеанса.ТекущаяОрганизация);
	
	результат = Запрос.Выполнить();
	Если Не результат.Пустой() И Пользователи.РолиДоступны("Методист",Неопределено) Тогда
		Возврат результат.Выгрузить()[0].АвтоматическиеНапоминанияПользователям;
	Иначе
		возврат Ложь;
	КонецЕсли;
КонецФункции
// }Рарус dotere #22114 -Автоматические напоминания используются или нет 2021.11.12

Функция ИспользованиеНапоминания() Экспорт
	Возврат Константы.ИспользоватьНапоминанияПользователя.Получить();
КонецФункции

Процедура ВвестиСтруктуруВоВременнуюТаблицу(ТекстЗапроса, СтруктураПараметров, ИмяВременнойТаблицы, ИмяВнешнейТаблицы) Экспорт
	
	ТекстЗапроса = ТекстЗапроса + "ВЫБРАТЬ ";
	Для Каждого КлючЗначение Из СтруктураПараметров Цикл
		ТекстЗапроса = ТекстЗапроса + Символы.ПС + ИмяВнешнейТаблицы + "." + КлючЗначение.Ключ + " КАК " + КлючЗначение.Ключ + ",";
	КонецЦикла;
	ТекстЗапроса = Сред(ТекстЗапроса,1,СтрДлина(ТекстЗапроса)-1);
	
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + " ПОМЕСТИТЬ " + ИмяВременнойТаблицы;
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + " ИЗ &" + ИмяВнешнейТаблицы + " КАК " + ИмяВнешнейТаблицы; 
	
КонецПроцедуры

Функция СформироватьЗаголовокФормы(Объект, ТекстФормы, Падеж) Экспорт
	ОбъектВДатПадеже = СклонениеПредставленийОбъектов.ПросклонятьПредставление(Объект.Наименование, Падеж, Объект);
	СтруткураФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ОбъектВДатПадеже);
	ФИО = "";
	Для Каждого КлючЗначениеФИО Из СтруткураФИО Цикл
		ФИО = ФИО + Врег(Лев(КлючЗначениеФИО.Значение, 1)) + Сред(КлючЗначениеФИО.Значение, 2) + " ";
	КонецЦикла;	
	Возврат ТекстФормы + " " + ФИО
КонецФункции

// {Рарус adilas #19051 -Отчисление из спортивного учреждения. Статус. 2021.08.31
Функция ТекущаяДатаНаСервере() Экспорт
	
	Возврат ТекущаяДатаСеанса();
	
КонецФункции
// }Рарус adilas #19051 -Отчисление из спортивного учреждения. Статус. 2021.08.31

// {Рарус adilas #20613 -РС Руководитель. Напоминания 2021.09.21
// Возвращает значение истина или ложь в зависимости от доступа к роли Рукводитель
Функция ЭтоРуководитель() Экспорт

	Если РольДоступна("Руководитель") Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции
// }Рарус adilas #20613 -РС Руководитель. Напоминания 2021.09.21

#КонецОбласти

#Область ОткрытиеФорм

Функция ОткрытьФормуРабочегоСтола() Экспорт
    
    Возврат РольДоступна("Тренер") И Не РольДоступна("ПолныеПрава")
    
КонецФункции

Функция ОткрытьФормуРабочегоСтолаМетодиста() Экспорт
    
    Возврат РольДоступна("Методист") И Не РольДоступна("ПолныеПрава")
    
КонецФункции	

Функция ОткрытьФормуРабочегоСтолаРуководителя() Экспорт
    
    Возврат РольДоступна("Руководитель") И Не РольДоступна("ПолныеПрава")
    
КонецФункции		

#КонецОбласти