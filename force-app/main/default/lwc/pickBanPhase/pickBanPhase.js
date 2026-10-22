import { LightningElement, api, track } from 'lwc';

import getWinConSetup from '@salesforce/apex/PickBanPhaseController.getWinConSetup';

export default class PickBanPhase extends LightningElement {


    @api matchObj;


    @track p1 = {
        name: '',
        picks: [],
        bans: [],
    };

    @track p2 = {
        name: '',
        picks: [],
        bans: [],
    };

    @track gamePool = [];
    @track winCon = [];

    currentPlayer;
    currentStep;
    isP1Turn = false;
    stepTitle;

    async connectedCallback(){

        if(!this.matchObj){
            console.error('Match Obj null');
        }

        this.winCon = [...await getWinConSetup({winCon: this.matchObj.match.winCon})]
        console.log(JSON.stringify(this.winCon));
        this.gamePool = [...this.matchObj.gamePool];
        this.p1.name = this.matchObj.p1.playerName;
        this.p2.name = this.matchObj.p2.playerName;

        this.switchTurn();

    }

    switchTurn(){
        if(this.isP1Turn){
            this.currentPlayer = this.p2.name;
            this.isP1Turn = false;
        } else {
            this.currentPlayer = this.p1.name;
            this.isP1Turn = true;
        }
        this.goToNextStep();
    }

    goToNextStep(){
        this.currentStep = this.winCon.shift();
        this.stepTitle = this.currentPlayer + ' have to ' + this.currentStep + ' a game';

    }

    onGameSelected(evt){
        const gameSelected = evt.detail.game;
        const gameSelectedIndex = this.gamePool.findIndex(game => game.gameId === gameSelected.gameId);
        this.gamePool.splice(gameSelectedIndex, 1);
        if(this.isP1Turn){
            if(this.currentStep === 'BAN'){
                this.p1.bans.push(gameSelected);
            } else {
                this.p1.picks.push(gameSelected);
            }
        } else {
            if(this.currentStep === 'BAN'){
                this.p2.bans.push(gameSelected);
            } else {
                this.p2.picks.push(gameSelected);
            }            
        }

        this.switchTurn();
    }

}