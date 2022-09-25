//=============================================================================
//Requires map changes and a custom playerpawn but should work in any version
//=============================================================================
class YeOldeFootStepSurface extends Keypoint;

#exec texture import file=Textures\yeoldfootstep.pcx name=i_YeOldeFootStep group=Icons flags=2 mips=off

var() enum EFeetVolumeType {
  FVT_RECTANGLE,
  FVT_OVAL,
  FVT_CUSTOM,
} FeetVolumeType;

var() float Width;
var() float Depth;
var() editconst string height_;
var() float Height;

var() Sound footstepSounds[8];
var() Sound landingSounds[8];

var() Actor testActor;

var color editorSelectColor;

final simulated function bool isActorAboveSurface(Actor playerPawn) {
  local vector playerRelativeLoc;
  if (abs(location.z - playerPawn.location.z) > height + playerPawn.collisionHeight) return false;
  switch(FeetVolumeType) {
    case FVT_RECTANGLE:
      playerRelativeLoc = (playerPawn.location - location) << rotation;
      return abs(playerRelativeLoc.x) <= (width + playerPawn.CollisionRadius) && abs(playerRelativeLoc.y) <= (depth  + playerPawn.CollisionRadius);
    case FVT_CUSTOM:
      return isActorAboveSurfaceCustom(playerPawn);
    default:
      return false;
  }
}

simulated function bool isActorAboveSurfaceCustom(Actor playerPawn) {
  log("override me in a custom subclass to do something useful");
  return false;
}

// built-in vect doesn't work properly for some reason without literals, need to use this
static function vector makeVector(float x, float y, optional float z) {
  local vector v;
  v.x = x;
  v.y = y;
  v.z = z;
  return v;
}

// if setting this up in 227 this function provides a visual guide of what areas are affected
event DrawEditorSelection(Canvas c) {
  local vector x, y;
  x = makeVector(width, 0, 0);
  y = makeVector(0, depth, 0);
  switch(FeetVolumeType) {
    case FVT_RECTANGLE:
      c.Draw3DLine(editorSelectColor, (location + (-x + y) >> rotation), (location + (-x - y) >> rotation));
      c.Draw3DLine(editorSelectColor, (location + (-x - y) >> rotation), (location + ( x - y) >> rotation));
      c.Draw3DLine(editorSelectColor, (location + ( x - y) >> rotation), (location + ( x + y) >> rotation));
      c.Draw3DLine(editorSelectColor, (location + ( x + y) >> rotation), (location + (-x + y) >> rotation));
      break;
    default:
      break;
  }

  if (testActor != none) {
    x = makeVector(testActor.location.x, testActor.location.y, location.z);
    if (isActorAboveSurface(testActor)) c.Draw3DLine(MakeColor(0,255,0), x, testActor.location);
    else c.Draw3DLine(MakeColor(255,0,0), x, testActor.location);
  }
}

defaultproperties {
  editorSelectColor=(R=240,G=140,B=73)
  height_="don't set the height too high"
  height=32
  width=128
  depth=128
  Texture=i_YeOldeFootStep
  bEditorSelectRender=true
}