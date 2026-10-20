public with sharing class MatchPickerController {


    @AuraEnabled
    public static string getMatchToRecord(String matchCode){
        try {
            return MatchUtils.getMatchByCode(matchCode);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}