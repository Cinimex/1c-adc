#Область СобытияЭлементовФормы

&НаСервере
Функция ПолучитьURLЛоготипа()
	
	Возврат асд_ОсновнойМодульСервер.ПолучитьURLЛоготипа();
	
КонецФункции

&НаКлиенте
Процедура ТекстАСДНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке(ПолучитьURLЛоготипа());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработанаОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Обработана", (ОбработанаОтбор > 1), , , (ОбработанаОтбор > 0));
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработанаОтбор = 1;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Обработана", (ОбработанаОтбор > 1), , , (ОбработанаОтбор > 0));
	
КонецПроцедуры

#КонецОбласти
  

