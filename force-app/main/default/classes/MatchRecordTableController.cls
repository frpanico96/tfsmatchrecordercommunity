public with sharing class MatchRecordTableController {


    @AuraEnabled
    public static TfsDto.MatchRecordDto getMatchesToRecord(String matchId){
        try {   
            return MatchRecordTableUtils.getMatchResultsForTable(matchId);
        } catch (Exception e) {
            LogService.insertTrace(Constants.MATCH_RECORD_PHASE, matchId, Constants.STATUS_ERROR, e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static Boolean saveMatchReport(String payload, String matchId){
        try {
            return MatchRecordTableUtils.saveMatchReport(payload, matchId);
        } catch (Exception e) {
            LogService.insertTrace(Constants.MATCH_RECORD_PHASE, matchId, Constants.STATUS_ERROR, e.getMessage());
            return false;
        }
    }

}