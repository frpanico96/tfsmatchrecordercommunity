public with sharing class MatchPickerController {


    @AuraEnabled
    public static TfsDto.MatchPickerDto getMatchToRecord(String matchCode){
        try {
            return MatchPickerUtils.getMatchDto(matchCode);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean isRecorderActive(){
        try {
            return MatchPickerUtils.isRecorderActive();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}