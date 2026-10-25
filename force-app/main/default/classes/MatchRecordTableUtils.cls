public without sharing class MatchRecordTableUtils {
    
    public static TfsDto.MatchRecordDto getMatchResultsForTable(String matchId){

        TfsDto.MatchRecordDto matchRecord = new TfsDto.MatchRecordDto();
        matchRecord.tableData = new List<TfsDto.MatchRecordTableDataDto>();

        SObjectAccessDecision securityDecision =
            Security.stripInaccessible(AccessType.READABLE, [
                SELECT Id,
                Match__r.Player1__r.Name,
                Match__r.Player2__r.Name,
                Match__r.SetWinCondition__c,
                Match__r.Name,
                Match__c,
                Game__r.Name,
                Set__c
                FROM MatchResult__c
                WHERE Match__c = :matchId
            ]);


        if(securityDecision.getRecords().size() > 0){

            List<MatchResult__c> matchResults = (List<MatchResult__c>) securityDecision.getRecords();

            matchRecord.matchId = matchResults[0].Match__c;
            matchRecord.matchName = matchResults[0].Match__r.Name;
            matchRecord.p1Name = matchResults[0].Match__r.Player1__r.Name;
            matchRecord.p2Name = matchResults[0].Match__r.Player2__r.Name;

            for(MatchResult__c mr : matchResults){
                TfsDto.MatchRecordTableDataDto tableRow = new TfsDto.MatchRecordTableDataDto();
                tableRow.id = mr.Id;
                tableRow.game = mr.Game__r.Name;
                tableRow.setnum = Integer.valueOf(mr.Set__c);
                tableRow.wincon = mr.Match__r.SetWinCondition__c;
                matchRecord.tableData.add(tableRow);
            }

        }

        return matchRecord;

    }



    public static Boolean saveMatchReport(String payload, String matchId){

        try {
            LogService.insertTrace(Constants.MATCH_RECORD_PHASE, matchId, null, payload);
        } catch (Exception e) {
            System.debug('Error in logging draft results' + e.getMessage());
        }


        List<TfsDto.MatchRecordTableDataDto> tableResults = 
            (List<TfsDto.MatchRecordTableDataDto>) JSON.deserialize(payload, List<TfsDto.MatchRecordTableDataDto>.class);
        
        List<SObject> sobjToUpdate = new List<SObject>();
        List<MatchResult__c> matchResults = new List<MatchResult__c>();

        Match__c match = new Match__c();
        match.Id = matchId;
        match.Status__c = 'Played';
        sobjToUpdate.add(match);

        for(TfsDto.MatchRecordTableDataDto tableResult : tableResults){
            MatchResult__c matchResult = new MatchResult__c();
            matchResult.Id = tableResult.id;
            matchResult.P1Score__c = tableResult.p1score != null ? Integer.valueOf(tableResult.p1score) : 0;
            matchResult.P2Score__c = tableResult.p2score != null ? Integer.valueOf(tableResult.p2score): 0;
            matchResult.DqPlayer1__c = tableResult.dqp1 != null ? Boolean.valueOf(tableResult.dqp1) : false;
            matchResult.DqPlayer2__c = tableResult.dqp2 != null ? Boolean.valueOf(tableResult.dqp2) : false;

            if(matchResult.DqPlayer1__c || (matchResult.P1Score__c < matchResult.P2Score__c)){
                matchResult.Result__c = 'P2';
            } else if(matchResult.DqPlayer2__c || (matchResult.P1Score__c > matchResult.P2Score__c)){
                matchResult.Result__c = 'P1';
            } else {
                matchResult.Result__c = 'DRAW';
            }

            matchResults.add(matchResult);

        }

        sobjToUpdate.addAll(matchResults);

        Database.update(sobjToUpdate, AccessLevel.SYSTEM_MODE);
        return true;
    }



}