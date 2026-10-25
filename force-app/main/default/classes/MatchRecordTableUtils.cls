public with sharing class MatchRecordTableUtils {
    
    public static TfsDto.MatchRecordDto getMatchResultsForTable(String matchId){

        TfsDto.MatchRecordDto matchRecord = new TfsDto.MatchRecordDto();
        matchRecord.tableData = new List<TfsDto.MatchRecordTableDataDto>();

        SObjectAccessDecision securityDecision =
            Security.stripInaccessible(AccessType.READABLE, [
                SELECT Id,
                Match__r.Player1__r.Name,
                Match__r.Player2__r.Name,
                Match__r.SetWinCondition__c,
                Match__c,
                Game__r.Name,
                Set__c
                FROM MatchResult__c
                WHERE Match__c = :matchId
            ]);


        if(securityDecision.getRecords().size() > 0){

            List<MatchResult__c> matchResults = (List<MatchResult__c>) securityDecision.getRecords();

            matchRecord.p1Name = matchResults[0].Match__r.Player1__r.Name;
            matchRecord.p2Name = matchResults[0].Match__r.Player2__r.Name;

            for(MatchResult__c mr : matchResults){
                TfsDto.MatchRecordTableDataDto tableRow = new TfsDto.MatchRecordTableDataDto();
                tableRow.game = mr.Game__r.Name;
                tableRow.setnum = Integer.valueOf(mr.Set__c);
                tableRow.wincon = mr.Match__r.SetWinCondition__c;
                matchRecord.tableData.add(tableRow);
            }

        }

        return matchRecord;

    }



}