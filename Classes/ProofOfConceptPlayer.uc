class ProofOfConceptPlayer extends FemaleTwo;

// overriding playFootStep() in 226b's UnrealIPlayer
simulated function PlayFootStep() {
  local Sound step;
  local int decision;
  local int i;
  local YeOldeFootStepSurface yeOldeFootStepSurface;

  if ( !bIsWalking && (Level.Game != None) && (Level.Game.Difficulty > 1) && ((Weapon == None) || !Weapon.bPointing) ) MakeNoise(0.05 * Level.Game.Difficulty);
  if ( FootRegion.Zone.bWaterZone ) {
    PlaySound(WaterStep, SLOT_Interact, 1, false, 1000.0, 1.0);
    return;
  }

  decision = rand(65535);
  foreach allactors(Class'YeOldeFootStepSurface', yeOldeFootStepSurface) {
    if (yeOldeFootStepSurface.isActorAboveSurface(self)) {
      for (i = 0; i < 8; i++) if (yeOldeFootStepSurface.footstepSounds[i] == none) break;
      step = yeOldeFootStepSurface.footstepSounds[decision % i];
      break;
    }
  }

  if (step == none) {
    if ( decision % 3 == 0) step = Footstep1;
    else if (decision % 3 == 1) step = Footstep2;
    else step = Footstep3;
  }

  if ( bIsWalking ) PlaySound(step, SLOT_Interact, 0.5, false, 400.0, 1.0);
  else PlaySound(step, SLOT_Interact, 2, false, 800.0, 1.0);
}

// overriding playLanded() in 436's Engine.Pawn
function PlayLanded(float impactVel) {
  local float landVol;
  local Sound step;
  local int decision;
  local int i;
  local YeOldeFootStepSurface yeOldeFootStepSurface;
  //default - do nothing (keep playing existing animation)
  landVol = impactVel/JumpZ;
  landVol = 0.005 * Mass * landVol * landVol;

  decision = rand(65535);
  foreach allactors(Class'YeOldeFootStepSurface', yeOldeFootStepSurface) {
    if (yeOldeFootStepSurface.isActorAboveSurface(self)) {
      for (i = 0; i < 8; i++) if (yeOldeFootStepSurface.landingSounds[i] == none) break;
      step = yeOldeFootStepSurface.landingSounds[decision % i];
      break;
    }
  }

  if (step == none) step = Land;

  PlaySound(step, SLOT_Interact, FMin(20, landVol));
}