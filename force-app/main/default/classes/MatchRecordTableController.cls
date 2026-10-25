public with sharing class MatchRecordTableController {


    @AuraEnabled
    public static TfsDto.MatchRecordDto getMatchesToRecord(String matchId){
        try {   
            return MatchRecordTableUtils.getMatchResultsForTable(matchId);
        } catch (Exception e) {
            LogService.insertTrace('Error Get Match Results', Constants.MATCH_RECORD_PHASE, Constants.STATUS_ERROR, e.getMessage());
        }
        return null;
    }


}