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
    matchObj;

    connectedCallback(){
        this.loading = true;
        this.load();
        this.isMatchPickerPhase = true;
    }


    async advanceToPickBanPhase(evt){
        this.isMatchPickerPhase = false;
        
        await this.load();
        
        const matchCode = evt.detail.matchCode
        this.matchObj = await getMatchToRecord({matchCode});
        console.log(this.matchObj);
        if(this.matchObj){
            await this.load();

            if(this.matchObj.match.status === 'Ready'){
                this.advanceToMatchRecordPhase();
                return;
            }

            if(this.matchObj.match.status === 'Played'){
                await this.advanceToClosingPhase();
                return;
            }

            this.isPickBanPhase = true;
        }

    }

    advanceToMatchRecordPhase(evt){
        console.log('Advancing to match report phase');
        this.isPickBanPhase = false;
        this.isMatchReportPhase = true;

    }

   async advanceToClosingPhase(evt){
        this.isMatchReportPhase = false;
        await this.load();
        this.isClosingPhase = true;
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