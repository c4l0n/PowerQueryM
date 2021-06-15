let
    Quelle = (Quellefkt_Par as any) => let
        Quelle = Quellefkt_Par,
        ColNames = Table.ColumnNames(Quelle),
        Benutzerdefiniert1 = Table.ToRows(Quelle),
        #"In Tabelle konvertiert" = Table.FromList(Benutzerdefiniert1, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Added Custom" = Table.AddColumn(#"In Tabelle konvertiert", "LastNonNull", each List.Last(List.RemoveNulls([Column1]))),
        #"Filtered Rows" = Table.SelectRows(#"Added Custom", each ([LastNonNull] <> null)),
        #"Added Custom1" = Table.AddColumn(#"Filtered Rows", "NonNullCount", each List.NonNullCount([Column1])),
        #"Added Custom2" = Table.AddColumn(#"Added Custom1", "NewList", each if [NonNullCount]=1 then [Column1] else List.ReplaceValue([Column1],[LastNonNull],null,Replacer.ReplaceValue)),
        #"Hinzugefügte benutzerdefinierte Spalte3" = Table.AddColumn(#"Added Custom2", "Records", each Record.FromList([NewList], ColNames)),
        #"Andere entfernte Spalten" = Table.SelectColumns(#"Hinzugefügte benutzerdefinierte Spalte3",{"Records"}),
        #"Erweiterte Records" = Table.ExpandRecordColumn(#"Andere entfernte Spalten", "Records", ColNames)
    in
        #"Erweiterte Records"
in
    Quelle