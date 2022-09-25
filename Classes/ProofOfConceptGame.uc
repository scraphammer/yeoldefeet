class ProofOfConceptGame extends UnrealGameInfo;

//force default player
event playerpawn Login(string Portal, string Options, out string Error, class<playerpawn> SpawnClass) {
  return super.Login(Portal, Options, Error, DefaultPlayerClass);
}


defaultproperties
{
  DefaultPlayerClass=Class'ProofOfConceptPlayer'
  DefaultWeapon=None
}