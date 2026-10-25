import { api, LightningElement } from 'lwc';

export default class GamePool extends LightningElement {

    @api mode;
    @api gamePool;
    @api btnDisabled = false;

}