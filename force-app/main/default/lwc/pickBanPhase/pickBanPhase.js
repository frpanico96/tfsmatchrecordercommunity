import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getWinConSetup from '@salesforce/apex/PickBanPhaseController.getWinConSetup';
import recordPickBanPhase from '@salesforce/apex/PickBanPhaseController.recordPickBanPhase';

const STEP_TITLE_BASE_CLASS = 'step-title slds-text-align_center slds-var-p-around_small';

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
    @track gamePoolMode = 'btn';
    @track deciderGame = {}
    @track stepTitleClass = STEP_TITLE_BASE_CLASS;

    isLoading;
    currentPlayer;
    currentStep;
    isP1Turn = false;
    stepTitle;
    pickBanPhase = true;
    closingStepTitle = ' a game:';
    confirmBtnDisabled = false;
    

    async connectedCallback(){

        this.isLoading = true;

        if(!this.matchObj){
            console.error('Match Obj null');
        }

        this.winCon = [...await getWinConSetup({winCon: this.matchObj.match.winCon})]
        console.log(JSON.stringify(this.winCon));
        this.gamePool = [...this.matchObj.gamePool];
        this.p1.name = this.matchObj.p1.playerName;
        this.p2.name = this.matchObj.p2.playerName;

        this.switchTurn();

        this.isLoading = false;
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
        
        if(this.currentStep === 'DECIDER'){
            this.pickDecider();
            return;
        }
        this.stepTitleClass = `${this.currentStep === 'BAN' ? 'ban-style' : 'pick-style'}`;
        this.stepTitle = this.currentPlayer + ' has to ';

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

    pickDecider(){
        const randomIndex = Math.floor(Math.random()* this.gamePool.length);
        this.deciderGame = {...this.gamePool[randomIndex]};
        this.stepTitle = '';
        this.stepTitleClass = 'pick-style';
        this.closingStepTitle = ':';
        this.pickBanPhase = false;
    }

    async confirmPickBan(evt){
        evt.preventDefault();
        
        this.confirmBtnDisabled = true;

        this.isLoading = true;
        
        const payload = this.buildPickBanResult();

        const success = await recordPickBanPhase({pickBanResult: JSON.stringify(payload)});

        console.log(payload, success);

        if(success){
            console.log('firing success event');
            this.dispatchEvent(new CustomEvent('pickbancompleted', {}));
        } else {
            console.error('error in creating matches to record');
        }

    }

    buildPickBanResult(){

        const result = {
            p1: {
                player: {...this.matchObj.p1},
                picks: [...this.p1.picks],
                bans: [...this.p1.bans],
            },
            p2: {
                player: {...this.matchObj.p2},
                picks: [...this.p2.picks],
                bans: [...this.p2.bans],
            },
            decider: {...this.deciderGame},
            match: {...this.matchObj.match}
        }

        return result;

    }

}