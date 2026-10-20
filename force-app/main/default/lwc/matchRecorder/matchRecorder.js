import { LightningElement } from 'lwc';

import getMatchToRecord from '@salesforce/apex/MatchPickerController.getMatchToRecord';


const LOAD_TIME_MS = 1000;

export default class MatchRecorder extends LightningElement {

    isMatchPickerPhase;
    isPickBanPhase;
    isConfirmPickBanPhase;
    isSuccessPhase;
    isMatchReportPhase;
    isClosingPhase;

    loading;
    matchId;

    connectedCallback(){
        this.loading = true;
        this.load();
        this.isMatchPickerPhase = true;
    }


    async advanceToPickBanPhase(evt){
        this.isMatchPickerPhase = false;
        
        await this.load();
        
        const matchCode = evt.detail.matchCode
        this.matchId = await getMatchToRecord({matchCode});
        
        if(this.matchId !== "NO RECORD FOUND"){
            await this.load();
            this.isPickBanPhase = true;
        }
    }

    async load(){
        this.loading = true;
        await this.wait(LOAD_TIME_MS);
        this.loading = false;
    }

    wait(mseconds) {
        return new Promise(resolve => {
            setTimeout(resolve, mseconds);
        });
    }

}