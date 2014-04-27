ITEM.Name = 'Detective'
ITEM.Price = 3000
ITEM.Material = 'vgui/ttt/sprite_det'
ITEM.SingleUse = false
ITEM.IgnoreIfSpecial = true // Ignore the force if the player is a detective or traitor

function ITEM:OnEquip(ply, modifications)
	hook.Add("TTTBeginRound", ply:UniqueID() .. "_detective", function()
		if ply:IsValid() then
			if self.IgnoreIfSpecial && ply:IsSpecial() then 
				ply:PS_Notify("Your detective role has been delayed a round because you were selected as a " .. ply:GetRoleString() .. " this round.")
				ply:PS_HolsterItem(self.ID)
				ply:PS_EquipItem(self.ID)
			else
				ply:PS_Notify("You have been forced to be a detective this round.")
				ply:SetRole(ROLE_DETECTIVE)
				ply:AddCredits(GetConVarNumber("ttt_credits_starting"))
				ply:PS_TakeItem(self.ID)
			end 
		end
	
		if SERVER then
			ply:PS_TakeItem(self.ID)
		end

		hook.Remove("TTTBeginRound", ply:UniqueID() .. "_detective")

	end)
end

function ITEM:OnHolster(ply)
	hook.Remove("TTTBeginRound", ply:UniqueID() .. "_detective")
	ply:PS_Notify("Your detective round has been canceled.")
end

function ITEM:OnSell(ply)
	hook.Remove("TTTBeginRound", ply:UniqueID() .. "_detective")
	ply:PS_Notify("Your detective round has been canceled.")
end
