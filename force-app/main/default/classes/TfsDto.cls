public with sharing class TfsDto {
    

    public class MatchPickerDto{
        @AuraEnabled
        public String torunamentId;
        @AuraEnabled
        public MatchDto match;
        @AuraEnabled
        public List<GamePoolDto> gamePool;
        @AuraEnabled
        public PlayerDto p1;
        @AuraEnabled
        public PlayerDto p2;
    }

    public class MatchDto{
        @AuraEnabled
        public String matchId;
        @AuraEnabled
        public String matchName;
        @AuraEnabled
        public String winCon;
        @AuraEnabled
        public String setWinCon;
    }

    public class GamePoolDto{
        @AuraEnabled
        public String gameId;
        @AuraEnabled
        public String gameName;
    }

    public class PlayerDto{
        @AuraEnabled
        public String playerId;
        @AuraEnabled
        public String playerName;
    }


}