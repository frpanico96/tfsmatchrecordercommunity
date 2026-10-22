public with sharing class MatchPickerController {


    @AuraEnabled
    public static TfsDto.MatchPickerDto getMatchToRecord(String matchCode){
        try {
            return MatchPickerUtils.getMatchDto(matchCode);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}