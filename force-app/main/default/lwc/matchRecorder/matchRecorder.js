import { LightningElement } from 'lwc';

import isRecorderActive from '@salesforce/apex/MatchPickerController.isRecorderActive';
import getMatchToRecord from '@salesforce/apex/MatchPickerController.getMatchToRecord';


const LOAD_TIME_MS = 1000;

export default class MatchRecorder extends LightningElement {

    isRecorderActive = true;

    isMatchPickerPhase;
    isPickBanPhase;
    isConfirmPickBanPhase;
    isSuccessPhase;
    isMatchReportPhase;
    isClosingPhase;

    loading;
    matchObj;

    async connectedCallback(){
        this.loading = true;
        this.isRecorderActive = await isRecorderActive();
        await this.load();
        this.isMatchPickerPhase = true;
    }


    async advanceToPickBanPhase(evt){
        this.isMatchPickerPhase = false;
        
        await this.load();
        this.isRecorderActive = await isRecorderActive();
        
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

    async advanceToMatchRecordPhase(evt){
        console.log('Advancing to match report phase');
        this.isRecorderActive = await isRecorderActive();
        this.isPickBanPhase = false;
        this.isMatchReportPhase = true;

    }

   async advanceToClosingPhase(evt){
        this.isMatchReportPhase = false;
        this.isRecorderActive = await isRecorderActive();
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