#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВидТипОбъекта(ИмяОбъекта)
	
	МассивСтрок = СтрРазделить(Объект["ТипОбъект" + ИмяОбъекта], ".");
	ЭтаФорма["ВидОбъект" + ИмяОбъекта] = МассивСтрок[0];
	ЭтаФорма["ТипОбъект" + ИмяОбъекта] = МассивСтрок[1];
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиОтбораПоОбъекту()
	
	Если НЕ ЗначениеЗаполнено(ТипОбъектОснование) Тогда
		Возврат;
	КонецЕсли;
	
	СпрОбъект = РеквизитФормыВЗначение("Объект");
	СхемаСКД = СпрОбъект.ПолучитьМакет("СКД_Данные");
	
	СхемаСКД.НаборыДанных.СписокОбъектов.Запрос = ПолучитьТекстЗапросаПоОбъекту(ВидОбъектОснование + "." + ТипОбъектОснование);
	
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаСКД, УникальныйИдентификатор);
	НастройкиОтбора.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));	
	НастройкиОтбора.ЗагрузитьНастройки(СхемаСКД.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстЗапросаПоОбъекту(ТипОбъекта)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	%ТипОбъекта%
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТипОбъекта%", ТипОбъекта);
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокОбъектовПоМетаданным()
	
	Справочники.асд_Правила.ЗаполнитьСписокВыбораВидовОбъектов(Элементы.ВидОбъектОснование.СписокВыбора);
	Справочники.асд_Правила.ЗаполнитьСписокВыбораВидовОбъектов(Элементы.ВидОбъектРезультат.СписокВыбора);
	
	Справочники.асд_Правила.ЗаполнитьСписокВыбораОбъектамиПоМетаданным(Элементы.ТипОбъектОснование.СписокВыбора, ВидОбъектОснование);
	Справочники.асд_Правила.ЗаполнитьСписокВыбораОбъектамиПоМетаданным(Элементы.ТипОбъектРезультат.СписокВыбора, ВидОбъектРезультат);
		
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДополнительныеНастройкиНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	СпрОбъект = РеквизитФормыВЗначение("Объект");
	
	// Заполним настройки заполнения
	СтруктураНастроек = СпрОбъект.НастройкиАСД.Получить();
	Если СтруктураНастроек <> Неопределено Тогда
		
		МассивРеквизитов = Неопределено;
		СтруктураНастроек.Свойство("МассивРеквизитов", МассивРеквизитов);
		
		Если МассивРеквизитов <> Неопределено Тогда
			Для каждого СтрокаРеквизита Из МассивРеквизитов Цикл
				ЗаполнитьЗначенияСвойств(ЭтаФорма.НастройкиАСД.Добавить(), СтрокаРеквизита);
			КонецЦикла; 
		КонецЕсли; 
		
		СтруктураНастроек.Свойство("ПрограммныйКод", ЭтаФорма.ПрограммныйКод);
		
	КонецЕсли; 
	
	// Заполним настройки отбора
	СтруктураНастроек = СпрОбъект.НастройкиОтбора.Получить();
	Если СтруктураНастроек <> Неопределено Тогда
		НастройкиОтбора.ЗагрузитьНастройки(СтруктураНастроек);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитовПоОбъекту()
	
	// Очищаем текущие реквизиты
	НастройкиАСД.Очистить();
	
	// Строим список выбора по шапке документа
	РеквизитСписокВыбора = Элементы.НастройкиАСДРеквизит.СписокВыбора;
	РеквизитСписокВыбора.Очистить();
	
	Если НЕ ЗначениеЗаполнено(ТипОбъектРезультат) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидОбъектРезультат) Тогда
		Возврат;
	КонецЕсли; 
	
	РеквизитыОбъекта = ПолучитьРеквизитыОбъектРезультат();
	
	Для каждого РеквизитОбъекта Из РеквизитыОбъекта  Цикл
		РеквизитСписокВыбора.Добавить(РеквизитОбъекта.Имя, РеквизитОбъекта.Синоним);
	КонецЦикла; 
	
	РеквизитСписокВыбора.СортироватьПоПредставлению();
	Элементы.НастройкиАСДРеквизит.РежимВыбораИзСписка = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОграничитьТипЗначенияРеквизита(идСтроки)
	
	ЭтаСтрока = НастройкиАСД.НайтиПоИдентификатору(идСтроки);
	
	Если НЕ ЗначениеЗаполнено(ЭтаСтрока.Реквизит) Тогда 
		ЭтаСтрока.ЗначениеРеквизита = Неопределено;
		Возврат; 
	КонецЕсли;
	
	РеквизитыОбъекта = ПолучитьРеквизитыОбъектРезультат();
	ОграничениеТипа = РеквизитыОбъекта[ЭтаСтрока.Реквизит].Тип;
	
	Элементы.НастройкиАСДЗначениеРеквизита.ОграничениеТипа = ОграничениеТипа;
	Элементы.НастройкиАСДЗначениеРеквизита.ВыбиратьТип = (ОграничениеТипа.Типы().Количество() > 1);
	ЭтаСтрока.ЗначениеРеквизита = ОграничениеТипа.ПривестиЗначение(ЭтаСтрока.ЗначениеРеквизита);
	
КонецПроцедуры

&НаСервере
Процедура ВидОбъектПриИзмененииНаСервере(ИмяЭлемента, ВидОбъект)
	
	Справочники.асд_Правила.ЗаполнитьСписокВыбораОбъектамиПоМетаданным(Элементы[ИмяЭлемента].СписокВыбора, ВидОбъект);
	
	Если ВидОбъектРезультат = "Справочник" Тогда
		Объект.ПроводитьПодчиненныеДокументы = Ложь;
		Объект.ДействиеСПодчиненнымиОбъектами = Перечисления.асд_ДействияСПодчиненнымиОбъектами.ОставитьКакЕсть;
	ИначеЕсли ВидОбъектРезультат = "Документ" Тогда
		Объект.ПроводитьПодчиненныеДокументы = Истина;
		Объект.ДействиеСПодчиненнымиОбъектами = Перечисления.асд_ДействияСПодчиненнымиОбъектами.ОтменитьПроведениеДерева;
	КонецЕсли;
	
	ОпределитьДоступностьРеквизитов();
		
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьРеквизитов()
	
	ЭтоДокумент = (ВидОбъектРезультат = "Документ");
	Элементы.ДействиеСПодчиненнымиОбъектами.Доступность = ЭтоДокумент; 	
	Элементы.ПроводитьПодчиненныеДокументы.Доступность 	= ЭтоДокумент; 	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРеквизитыОбъектРезультат()
	
	Если ВидОбъектРезультат = "Документ" Тогда
		РеквизитыОбъекта = Метаданные.Документы[ТипОбъектРезультат].Реквизиты;
	ИначеЕсли ВидОбъектРезультат = "Справочник" Тогда
		РеквизитыОбъекта = Метаданные.Справочники[ТипОбъектРезультат].Реквизиты;
	КонецЕсли; 
	
	Возврат РеквизитыОбъекта;
	
КонецФункции

&НаСервере
Процедура СформироватьНаименованиеСервер()
	
	Если ЗначениеЗаполнено(ТипОбъектОснование) И ЗначениеЗаполнено(ТипОбъектРезультат) Тогда
		Объект.Наименование = СокрЛП(Элементы.ТипОбъектОснование.СписокВыбора.НайтиПоЗначению(ТипОбъектОснование).Представление)
				+ " ---> " + СокрЛП(Элементы.ТипОбъектРезультат.СписокВыбора.НайтиПоЗначению(ТипОбъектРезультат).Представление);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьВидТипОбъекта("Основание");
		ЗаполнитьВидТипОбъекта("Результат");
	КонецЕсли; 
	
	ЗаполнитьСписокОбъектовПоМетаданным();
	
	УстановитьНастройкиОтбораПоОбъекту();
	ЗаполнитьСписокРеквизитовПоОбъекту();
	ЗагрузитьДополнительныеНастройкиНаСервере();
	
	ОпределитьДоступностьРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Сохраним настройки заполнения
	СтруктураНастроек = Новый Структура();
	СтруктураНастроек.Вставить("МассивРеквизитов", ОбщегоНазначения.ТаблицаЗначенийВМассив(НастройкиАСД.Выгрузить()));
	СтруктураНастроек.Вставить("ПрограммныйКод", ПрограммныйКод);
	ТекущийОбъект.НастройкиАСД = Новый ХранилищеЗначения(СтруктураНастроек);
	
	// Сохраним настройки отбора
	ТекущийОбъект.НастройкиОтбора = Новый ХранилищеЗначения(НастройкиОтбора.ПолучитьНастройки());
	
	ТекущийОбъект.ТипОбъектОснование = ВидОбъектОснование + "." + ТипОбъектОснование;
	ТекущийОбъект.ТипОбъектРезультат = ВидОбъектРезультат + "." + ТипОбъектРезультат;
	
	Если НЕ ТекущийОбъект.КонтрольПравилаАСД() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
 
#Область СобытияЭлементовФормы

&НаКлиенте
Процедура ТипДокументОснованиеПриИзменении(Элемент)
	
	УстановитьНастройкиОтбораПоОбъекту();
	СформироватьНаименованиеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументРезультатПриИзменении(Элемент)
	
	ЗаполнитьСписокРеквизитовПоОбъекту();
	СформироватьНаименованиеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиАСДПриАктивизацииЯчейки(Элемент)
	
	ТекущаяКолонка = Элементы.НастройкиАСД.ТекущийЭлемент;
	
	Если ТекущаяКолонка.Имя = "НастройкиАСДЗначениеРеквизита" Тогда
		ЭтаСтрока = Элементы.НастройкиАСД.ТекущиеДанные;
		Если ЭтаСтрока <> Неопределено Тогда
			ОграничитьТипЗначенияРеквизита(ЭтаСтрока.ПолучитьИдентификатор());
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОбъектОснованиеПриИзменении(Элемент)
	
	ТипОбъектОснование = "";
	
	ВидОбъектПриИзмененииНаСервере("ТипОбъектОснование", ВидОбъектОснование);
	ТипДокументОснованиеПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОбъектРезультатПриИзменении(Элемент)
	
	ТипОбъектРезультат = "";
	
	ВидОбъектПриИзмененииНаСервере("ТипОбъектРезультат", ВидОбъектРезультат);
	ТипДокументРезультатПриИзменении(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьНаименование(Команда)
	
	СформироватьНаименованиеСервер();
	
КонецПроцедуры

#КонецОбласти

 




