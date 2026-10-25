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

    public class PickBanResultDto {

        @AuraEnabled
        public PickBanPlayerDto p1;
        @AuraEnabled
        public PickBanPlayerDto p2;
        @AuraEnabled
        public GamePoolDto decider;
        @AuraEnabled
        public MatchDto match;
        
    }

    public class MatchRecordDto {

        @AuraEnabled
        public String p1Name;
        @AuraEnabled
        public String p2Name;
        @AuraEnabled
        public List<MatchRecordTableDataDto> tableData;
        
    }

    public class MatchRecordTableDataDto {

        @AuraEnabled
        public Integer setnum;
        @AuraEnabled
        public String game;
        @AuraEnabled
        public String wincon;

    }


    public class PickBanPlayerDto{

        @AuraEnabled
        public PlayerDto player;
        @AuraEnabled
        public List<GamePoolDto> picks;
        @AuraEnabled
        public List<GamePoolDto> bans;

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