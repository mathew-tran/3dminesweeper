extends HBoxContainer

class_name MoneyUI

enum UI_STATE {
	AFFORD,
	CANNOT_AFFORD
}
func Update(amount, bCanAfford = true):
	if bCanAfford:
		$Label.modulate = Color.WHITE
	else:
		$Label.modulate = Color.RED
	$Label.text = str(amount)
