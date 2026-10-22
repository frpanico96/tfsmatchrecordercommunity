public with sharing class PickBanPhaseController {
    
    @AuraEnabled
    public static List<String> getWinConSetup(String winCon){
        try {
            return PickBanPhaseUtils.getWinCon(winCon);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }



}