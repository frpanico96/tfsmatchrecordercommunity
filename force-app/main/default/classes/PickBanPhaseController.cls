public with sharing class PickBanPhaseController {
    
    @AuraEnabled
    public static List<String> getWinConSetup(String winCon){
        try {
            return PickBanPhaseUtils.getWinCon(winCon);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean recordPickBanPhase(String pickBanResult){
        try {
            return PickBanPhaseUtils.pickBanPhaseRecord(pickBanResult);
        } catch (Exception e) {
            LogService.insertTrace(Constants.PICK_BAN_PHASE, 'error_recording', Constants.STATUS_ERROR, e.getMessage());
            return false;
        }
    }

    @AuraEnabled
    public static void tracePickBanPhase(String pickBanPayload, String matchId){
        try {
            
            LogService.insertTrace(Constants.PICK_BAN_PHASE, matchId, null, pickBanPayload);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}