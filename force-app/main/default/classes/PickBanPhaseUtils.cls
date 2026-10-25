public with sharing class PickBanPhaseUtils {


    public static List<String> getWinCon(String winCon){

        SObjectAccessDecision securityDecision = 
            Security.stripInaccessible(AccessType.READABLE, [
                SELECT Id,Setup__c
                FROM WinConSetup__c
                WHERE WinCondition__c = :winCon
            ]);
        
        if(securityDecision.getRecords().size() > 0){
            return ((WinConSetup__c)securityDecision.getRecords()[0]).Setup__c.split(',');
        }

        return new List<String>();

    }

    public static Boolean pickBanPhaseRecord(String resultString){

        
        
        TfsDto.PickBanResultDto result = (TfsDto.PickBanResultDto) JSON.deserialize(resultString, TfsDto.PickBanResultDto.class);
        List<SObject> sobjToUpsert = new List<Sobject>();
        List<String> winConsSetup = getWinCon(result.match.winCon);
        List<Step__c> steps = new List<Step__c>();
        List<MatchResult__c> matchResults = new List<MatchResult__c>();
        Boolean isP1 = false;
        String lastStep;
        
        for(String step : winConsSetup){
            Step__c pickBanPhaseStep = new Step__c();
            pickBanPhaseStep.Match__c = result.match.matchId;
            pickBanPhaseStep.Type__c = step;
            
            if('DECIDER'.equalsIgnoreCase(step)){
                pickBanPhaseStep.Game__c = result.decider.gameId;
                pickBanPhaseStep.Name = step;
                steps.add(pickBanPhaseStep);
                continue;
            }
            
            if(isP1){
                pickBanPhaseStep.Player__c = result.p2.player.playerId;
                switch on step {
                    when 'PICK' {
                        pickBanPhaseStep.Game__c = result.p2.picks.remove(0).gameId;
                    }
                    when else {
                        pickBanPhaseStep.Game__c = result.p2.bans.remove(0).gameId;
                    }
                }
                pickBanPhaseStep.Name = result.p2.player.playerName + step;
                isP1 = false;
            } else {
                pickBanPhaseStep.Player__c = result.p1.player.playerId;
                switch on step {
                    when 'PICK' {
                        pickBanPhaseStep.Game__c = result.p1.picks.remove(0).gameId;
                    }
                    when else {
                        pickBanPhaseStep.Game__c = result.p1.bans.remove(0).gameId;
                    }
                }
                pickBanPhaseStep.Name = result.p1.player.playerName + step;
                isP1 = true;               
            }
            steps.add(pickBanPhaseStep);
        }
        Integer setNum = 1;
        for(Step__c step : steps){
            if('BAN'.equalsIgnoreCase(step.Type__c)){
                continue;
            }
            MatchResult__c mr = new MatchResult__c();
            mr.Match__c = result.match.matchId;
            mr.Game__c = step.Game__c;
            mr.Name = 'Match ' + setNum;
            mr.Set__c = setNum;
            matchResults.add(mr);
            setNum++;
        }
        
        Match__c match = new Match__c();
        match.Id = result.match.matchId;
        match.Status__c = 'Ready';
        
        sobjToUpsert.addAll(steps);
        sobjToUpsert.addAll(matchResults);
        sobjToUpsert.add(match);
        

        Database.upsert(sobjToUpsert, AccessLevel.SYSTEM_MODE);
        return true;
    }

}