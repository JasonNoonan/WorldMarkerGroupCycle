local _, addon = ...

function table.move(a1, s, e, t, a2)
	if not a2 then
		a2 = {}
	end

	for i = 0, e - 1 do
		a2[t + i] = a1[s + i]
	end
end

function addon.Addon:PrintOrderedTable(tab)
	addon.Addon:Print(table.concat(tab, ", "))
end
