import { LightningElement } from 'lwc';



export default class MatchPicker extends LightningElement {

    matchCode;

    handleChange(evt){
        this.matchCode = evt.target.value;
    }

    handleClick(evt){
        evt.preventDefault();

        this.dispatchEvent(new CustomEvent('matchpicked', {detail:{matchCode: this.matchCode}}));
    }


}