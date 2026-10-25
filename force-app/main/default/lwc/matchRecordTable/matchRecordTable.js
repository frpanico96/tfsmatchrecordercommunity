import { LightningElement, track, api } from 'lwc';

import getMatchesToRecord from '@salesforce/apex/MatchRecordTableController.getMatchesToRecord';

const matchResultsCol = [
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

    isLoading;




    async connectedCallback(){
        this.isLoading = true;
        console.log(this.matchId)

        const matchesToRecord = await getMatchesToRecord({matchId: this.matchId});

        console.log(JSON.stringify(matchesToRecord));

    }
}