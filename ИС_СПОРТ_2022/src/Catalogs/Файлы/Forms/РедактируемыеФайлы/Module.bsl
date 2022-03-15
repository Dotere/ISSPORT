
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Пользователь = Пользователи.ТекущийПользователь();
	Список.Параметры.УстановитьЗначениеПараметра("Редактирует", Пользователь);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиСлужебныйВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.СписокТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
	
	ЗавершениеРаботыПрограммы = Неопределено;
	Если Параметры.Свойство("ЗавершениеРаботыПрограммы", ЗавершениеРаботыПрограммы) Тогда 
		Ответ = ЗавершениеРаботыПрограммы;
		Если Ответ = Истина тогда
			Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость 	= Ответ;
			Элементы.ГруппаКоманднойПанели.Видимость 						= Ответ;
		КонецЕсли;
	КонецЕсли;
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

// Обработка события Выбор у списка 
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ВыбраннаяСтрока,
		Неопределено,
		УникальныйИдентификатор);
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		УстановитьДоступностьКоманд(Ложь);
	Иначе
		УстановитьДоступностьКоманд(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(
		Неопределено,
		ТекущиеДанные.Ссылка,
		УникальныйИдентификатор,
		ТекущиеДанные.ХранитьВерсии,
		Истина, // РедактируетТекущийПользователь
		ТекущиеДанные.Редактирует,
		ТекущиеДанные.ТекущаяВерсияАвтор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущаяСтрока;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлСОповещением(
		Неопределено,
		СтрокаТаблицы,
		ТекущиеДанные.ХранитьВерсии,
		Истина, // РедактируетТекущийПользователь
		ТекущиеДанные.Редактирует);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущаяСтрока;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.ОпубликоватьФайлСОповещением(
		Неопределено,
		СтрокаТаблицы,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущаяСтрока;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		СтрокаТаблицы,
		Неопределено,
		УникальныйИдентификатор);
	
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущаяСтрока;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(СтрокаТаблицы);
	
	РаботаСФайламиСлужебныйКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Неопределено,
		ДанныеФайла,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	МассивСтруктур = Новый Массив;
	
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиПрограммы",
	    "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
	    ПоказыватьЗанятыеФайлыПриЗавершенииРаботы));
		
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	Закрыть();	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьКоманд(Доступность)
	Элементы.ФормаЗакончитьРедактирование.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюЗакончитьРедактирование.Доступность = Доступность;
	
	Элементы.ФормаОткрыть.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОткрыть.Доступность = Доступность;
	
	Элементы.ФормаИзменить.Доступность = Доступность;
	
	Элементы.СписокКонтекстноеМенюСохранитьИзменения.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОткрытьКаталогФайла.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюСохранитьКак.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОсвободить.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОбновитьИзФайлаНаДиске.Доступность = Доступность;
КонецПроцедуры

Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

#КонецОбласти
