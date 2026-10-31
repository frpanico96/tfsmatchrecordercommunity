import { LightningElement, track, api } from 'lwc';

import getMatchesToRecord from '@salesforce/apex/MatchRecordTableController.getMatchesToRecord';
import saveMatchReport from '@salesforce/apex/MatchRecordTableController.saveMatchReport';

const MATCH_RESULT_COL = [
    {
        label: 'Set',
        type: 'number',
        fieldName: 'setnum',
    },
    {
        label: 'Game',
        fieldName: 'game',
    },
    {
        label: 'FT#',
        fieldName: 'wincon',
    },
    {
        label: 'P1 Score',
        fieldName: 'p1score',
        type: 'number',
        editable: true,
    },
    {
        label: 'P2 Score',
        fieldName: 'p2score',
        type: 'number',
        editable: true,
    },
    {
        label: 'DQ P1',
        fieldName: 'dqp1',
        type: 'boolean',
        editable: true,
    },
    {
        label: 'DQ P2',
        fieldName: 'dqp2',
        type: 'boolean',
        editable: true,
    },

]


export default class MatchRecordTable extends LightningElement {

    @api matchId;

    @track cardTitle;
    @track matchResults;
    @track draftValues;
    @track matchResultsCol;

    isLoading;




    async connectedCallback(){
        this.isLoading = true;
        this.matchResultsCol = [...MATCH_RESULT_COL];
        console.log(this.matchId)

        const matchesToRecord = await getMatchesToRecord({matchId: this.matchId});

        console.log(JSON.stringify(matchesToRecord));
        this.cardTitle = `${matchesToRecord.matchName}: ${matchesToRecord.p1Name} vs ${matchesToRecord.p2Name}`;
        this.matchResults = [...matchesToRecord.tableData];
        
        this.isLoading = false;
    }

    async handleSave(evt){
        evt.preventDefault();
        console.log('Saving event');
        console.log(JSON.stringify(evt.detail.draftValues));

        const payloadArr = evt.detail.draftValues.map(el => {
            
            const newEl = {...el};
            
            if(newEl.p1score === ""){
                newEl.p1score = null;
            }
            if(newEl.p2score === ""){
                newEl.p2score = null;
            }

            return newEl;
        });

        const payload = JSON.stringify(payloadArr);
        const success = await saveMatchReport({payload, matchId: this.matchId});
        console.log(payload, success);
        this.isLoading = true;
        this.dispatchEvent(new CustomEvent('reportcomplete', {}));
    }
}