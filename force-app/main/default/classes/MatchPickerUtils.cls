public with sharing class MatchPickerUtils {
    
    public static TfsDto.MatchPickerDto getMatchDto(String matchCode){

        TfsDto.MatchPickerDto result = new TfsDto.MatchPickerDto();

        Match__c match = getMatchByCode(matchCode);

        result.torunamentId = match.Tournament__c;

        /* Match DTO */
        result.match = new TfsDto.MatchDto();
        result.match.matchId = match.Id;
        result.match.matchName = match.Name;
        result.match.setWinCon = match.SetWinCondition__c;
        result.match.winCon = match.WinCondition__c;

        /* P1P2 DTO */
        result.p1 = new TfsDto.PlayerDto();
        result.p1.playerId = match.Player1__c;
        result.p1.playerName = match.Player1__r.Name;

        result.p2 = new TfsDto.PlayerDto();
        result.p2.playerId = match.Player2__c;
        result.p2.playerName = match.Player2__r.Name;


        /* GamePool DTO */
        List<GamePool__c> gamePool = getGamePoolByTournamentId(match.Tournament__c);

        result.gamePool = new List<TfsDto.GamePoolDto>();
        for(GamePool__c gp : gamePool){
            TfsDto.GamePoolDto gpDto = new TfsDto.GamePoolDto();
            gpDto.gameId = gp.Game__c;
            gpDto.gameName = gp.Game__r.Name;
            result.gamePool.add(gpDto);
        }
        String matchKey = match.Name + '_' + match.Id;
        LogService.insertTrace(Constants.MATCH_PICKER_PHSAE, matchKey , Constants.STATUS_SUCCESS, JSON.serialize(result));

        return result;

    }


    private static Match__c getMatchByCode(String matchCode){

        SObjectAccessDecision securityDecision =
            Security.stripInaccessible(AccessType.READABLE, [
                SELECT Id,
                Name,
                Player1__c,
                Player1__r.Name,
                Player2__c,
                Player2__r.Name,
                SetWinCondition__c,
                WinCondition__c,
                Tournament__c,
                Status__c
                FROM Match__c
                WHERE UID__c = :matchCode
            ]);

        if(securityDecision.getRecords().size() > 0){
            return (Match__c)securityDecision.getRecords()[0];
        }

        return null;
    }

    private static List<GamePool__c> getGamePoolByTournamentId(String torunamentId){

        SObjectAccessDecision securityDecision =
            Security.stripInaccessible(AccessType.READABLE, [
                SELECT Id,
                Game__r.Name,
                Game__c
                FROM GamePool__c
                WHERE Tournament__c = :torunamentId
                ORDER BY Order__c ASC
            ]);

        if(securityDecision.getRecords().size() > 0){
            return ((List<GamePool__c>) securityDecision.getRecords());
        }

        return null;
    }

}