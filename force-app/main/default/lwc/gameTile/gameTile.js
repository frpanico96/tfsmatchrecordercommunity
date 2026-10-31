import { LightningElement, api } from 'lwc';

export default class GameTile extends LightningElement {

    @api mode;
    @api gameObj;
    @api btnDisabled = false;

    get isTile(){
        return this.mode === 'tile'
    }

    get isBtn() {
        return this.mode === 'btn'
    }

    handleClick(evt){
        evt.preventDefault();
        console.log('game picked');
        this.dispatchEvent(new CustomEvent('gameselected', {detail: {game: this.gameObj}, bubbles: true, composed: true}));
    }

}