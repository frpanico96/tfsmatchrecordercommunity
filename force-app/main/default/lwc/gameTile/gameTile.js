import { LightningElement, api } from 'lwc';

export default class GameTile extends LightningElement {

    @api mode;
    @api gameObj;

    isTile = false;
    isBtn = false;

    connectedCallback(){
        this.isTile = this.mode === 'tile';
        this.isBtn = this.mode === 'btn';
    }

    handleClick(evt){
        evt.preventDefault();
        console.log('game picked');
        this.dispatchEvent(new CustomEvent('gameselected', {detail: {game: this.gameObj}, bubbles: true, composed: true}));
    }

}