qView[g_] := Module[
		{fileName},
		fileName = FileNameJoin[{
			"~",
			"tmp",
      "Wolfram-output-image",
			StringReplace[
				DateString["ISODateTime"], 
				":" -> "-"
			] <> ".png"
		}];
		Export[fileName, g];
		Run["kitten icat " <> fileName];
	]


$Post = Replace[#, {Alternatives[_Graphics, _Image] :> qView[#]}] &
