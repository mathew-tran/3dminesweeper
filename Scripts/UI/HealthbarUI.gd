extends ProgressBar

@export var HealthComponentRef : HealthComponent

func _ready() -> void:
	if is_instance_valid(HealthComponentRef):
		Setup()
	
func Setup():
	HealthComponentRef.OnTakeDamage.connect(OnTakeDamage)
	Update()

func Update():
	$Label.text = str(HealthComponentRef.CurrentHealth) + "/" + str(HealthComponentRef.MaxHealth)
	value = float(HealthComponentRef.CurrentHealth) / float(HealthComponentRef.MaxHealth)
func OnTakeDamage(amount):
	Update()
