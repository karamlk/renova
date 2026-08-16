import "./Complainthandlingdialog.css";
//MUI
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import TagIcon from '@mui/icons-material/Tag';
import PersonIcon from '@mui/icons-material/Person';
import PersonOffIcon from '@mui/icons-material/PersonOff';
import PercentIcon from '@mui/icons-material/Percent';
import EditIcon from '@mui/icons-material/Edit';
import CloseIcon from '@mui/icons-material/Close';
import CheckIcon from '@mui/icons-material/Check';
//Hooks
import {useState} from "react";
import { useTranslation } from 'react-i18next';
//Components
import Button from "../../components/Button/Button";
import Dialogform from "../Dialogform/Dialogform";
export default function Complainthandlingdialog({id,complainant_name,complainton_name,onApply,onClose}){
    const {t}=useTranslation();
    const [penalty, setPenalty] = useState("");
    const [reason, setReason] = useState("");
    function handleAccept(e){
        e.preventDefault();
        onApply({penalty_percentage: penalty,admin_processing_note: reason});
    }
    return(
        <div>
    <Dialogform
        title={"معالجة الشكوى"} 
        icon={<CheckCircleIcon sx={{color: '#4CAF50'}}/>}
        h="81vh" 
        w="500px"
        b1={<Button type="button" className="cancel" onClick={onClose} text="إلغاء" icon={<CloseIcon/>}/>}
        b2={<Button form="complaintForm" type="submit" className="process" text="معالجة" icon={<CheckIcon/>}/>}
        borderclr="#4CAF50"
        >
                <div class="complaint-card">
                    <div class="item">
                        <TagIcon sx={{color: '#4CAF50'}}/>
                        <span class="label">{t("رقم الشكوى")}:</span>
                        <span class="value">#{id}</span>
                    </div>
                    <div class="item">
                        <PersonIcon sx={{color: '#4CAF50'}}/>
                        <span class="label">{t("المشتكي")}:</span>
                        <span class="value">{complainant_name}</span>
                    </div>
                    <div class="item">
                        <PersonOffIcon sx={{color: '#4CAF50'}}/>
                        <span class="label">{t("المشكى عليه")}:</span>
                        <span class="value">{complainton_name}</span>
                    </div>
                </div>   
                <form id="complaintForm" onSubmit={handleAccept}>
                    <div className="complaint-form-group">
                        <label for="discount">
                            <PercentIcon sx={{color: '#4CAF50' , fontSize: '20px'}}/>
                            {t("نسبة الخصم")} ({t("اختياري")})
                        </label>
                        <div className="discount-input-wrapper">
                            <input
                                type="number"
                                id="discount"
                                placeholder={t("أدخل نسبة الخصم")}
                                min="0"
                                max="100"
                                value={penalty}
                                onChange={(e)=>setPenalty(e.target.value)}
                            />
                            <span className="discount-symbol"><PercentIcon sx={{color: '#4CAF50' , fontSize: '20px'}}/></span>
                        </div>
                    </div>

                    <div className="complaint-form-group">
                        <label for="reason">
                            <EditIcon sx={{color: '#4CAF50' , fontSize: '20px'}}/>{t("سبب معالجة الشكوى")} *
                        </label>
                        <textarea
                            id="reason"
                            placeholder={t("اكتب سبب معالجة الشكوى هنا...")}
                            maxlength="500"
                            required
                            value={reason}
                            onChange={(e)=>setReason(e.target.value)}
                        ></textarea>
                    </div>
                </form>         
        </Dialogform>
        </div>
    )
}