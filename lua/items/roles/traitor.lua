ITEM.Name = 'Traitor'
ITEM.Price = 3000
ITEM.Material = 'vgui/ttt/sprite_traitor'
ITEM.SingleUse = false
ITEM.IgnoreIfSpecial = true // Ignore the force if the player is a detective or traitor

function ITEM:OnEquip(ply, modifications)
	hook.Add("TTTBeginRound", ply:UniqueID() .. "_traitor", function()
		if ply:IsValid() then
			if self.IgnoreIfSpecial && ply:IsSpecial() then 
				ply:PS_Notify("Your traitor role has been delayed a round because you were selected as a " .. ply:GetRoleString() .. " this round.")
				ply:PS_HolsterItem(self.ID)
				ply:PS_EquipItem(self.ID)
			else
				ply:PS_Notify("You have been forced to be a traitor this round.")
				ply:SetRole(ROLE_TRAITOR)
				ply:AddCredits(GetConVarNumber("ttt_credits_starting"))
				ply:PS_TakeItem(self.ID)
			end 
		end
		hook.Remove("TTTBeginRound", ply:UniqueID() .. "_traitor")
	end)
end

function ITEM:OnHolster(ply)
	hook.Remove("TTTBeginRound", ply:UniqueID() .. "_traitor")
	ply:PS_Notify("Your traitor round has been canceled.")
end

function ITEM:OnSell(ply)
	hook.Remove("TTTBeginRound", ply:UniqueID() .. "_traitor")
	ply:PS_Notify("Your traitor round has been sold.")
end
