///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка -
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ДатаНачала");
	Результат.Добавить("ДатаОкончания");
	Результат.Добавить("ВозможностьПредварительногоСохранения");
	Результат.Добавить("ПоказыватьВАрхивеАнкет");
	Результат.Добавить("Комментарий");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//  КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//  Параметры - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.АнализОпроса) Тогда
		Команда = КомандыОтчетов.Добавить();
		Команда.Представление      = НСтр("ru = 'Анализ опроса'");
		Команда.МножественныйВыбор = Ложь;
		Команда.ИмяПараметраФормы  = "Опрос";
		Команда.РежимЗаписи        = "Записывать";
		Команда.Менеджер           = "Отчет.АнализОпроса";
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получателей SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS;
//     * Представление - Строка - представление получателя сообщения SMS;
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки;
//    * ПараметрыСообщения - Структура - Дополнительные параметры сообщения.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей почты при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя;
//     * Представление   - Строка - представление получателя письма;
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки письма;
//    * ПараметрыСообщения - Структура - Дополнительные параметры сообщения;
//    * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - признак преобразование HTML текста
//             сообщения содержащего картинки в тексте письма из-за особенностей вывода изображений
//             в форматированном документе;
//    * УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись для отправки письма.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений

#КонецОбласти

#КонецОбласти

#КонецЕсли

