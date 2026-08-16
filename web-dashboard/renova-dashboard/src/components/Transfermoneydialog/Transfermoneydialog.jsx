import "./Transfermoneydialog.css";
//MUI
import MonetizationOnIcon from '@mui/icons-material/MonetizationOn';
import AttachMoneyIcon from '@mui/icons-material/AttachMoney';
import ClearIcon from '@mui/icons-material/Clear';
import TelegramIcon from '@mui/icons-material/Telegram';
//Hooks
import { useState } from "react";
import { useTranslation } from 'react-i18next';
//Utils
import {formatMoney} from "../../utils/formatMoney";
//Components
import Button from '../Button/Button';
import Dialogform from '../Dialogform/Dialogform';

export default function Transfermoneydialog({onApply,onclose,id,payment_amount,remaining_amount}) {
    const [t] = useTranslation();
    const [amount, setAmount] = useState("");
    return (
    <>
    <Dialogform
        title={"تحويل المبلغ"} 
        icon={<MonetizationOnIcon sx={{color: "#f07c1f" , fontSize: "28px"}}/>}
        h="46vh" 
        w="480px"
        b1={<Button type="button" className="cancel" onClick={onclose} text="إلغاء" icon={<ClearIcon/>}/>}
        b2={<Button form="Transfer-form" type="submit" className="accept" text="تحويل" icon={<TelegramIcon/>}/>}
        >
                <div className="Transfer-payment-info">
                    <div>
                        <span className="Transfer-label">{t("رقم الدفعة")}</span>
                        <div className="Transfer-value">#{id}</div>
                    </div>
                    <div>
                        <span className="Transfer-label">{t("المبلغ الإجمالي")}</span>
                        <div className="Transfer-value">${formatMoney(payment_amount)}</div>
                    </div>
                    <div>
                        <span className="Transfer-label">{t("المتبقي")}</span>
                        <div className="Transfer-value">${formatMoney(remaining_amount)}</div>
                    </div>
                </div>

                <form id="Transfer-form" onSubmit={(e) => {e.preventDefault();onApply(amount);}}>
                    <div className="Transfer-form-group">
                        <label htmlFor="amount">
                            <AttachMoneyIcon sx={{color: "#f07c1f" , fontSize: "21px"}}/>
                            {t("المبلغ المراد تحويله")}
                        </label>
                        <div className="Transfer-input-wrapper">
                            <input
                                type="number"
                                id="amount"
                                placeholder={t("أدخل المبلغ")}
                                min="1"
                                step="1"
                                required
                                value={amount}
                                onChange={(e) => setAmount(e.target.value)}
                            />
                        </div>
                    </div>
                </form>
        </Dialogform>
    </>
    )
   
} 