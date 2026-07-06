import "./Engineerlistdialog.css";
//MUI Icons
import EngineeringIcon from '@mui/icons-material/Engineering';
//Hooks
import { useTranslation } from 'react-i18next';
export default function Engineerlistdialog({children,onClose,onApply}) {
    const {t}=useTranslation();
    return(
        <div class="eng-dialog-overlay">
        <div class="eng-dialog-box" >
            <div class="eng-dialog-header">
                <h3><EngineeringIcon sx={{color: "#f07c1f",fontSize:30}} />{t("اختيار مهندس")}</h3>
            </div>
            <div class="eng-dialog-body">
                <div id="engineersList">
                    {children}      
                </div>
            </div>
            <div class="eng-dialog-footer">
                <button class="btn-cancel" onClick={onClose}>{t("إلغاء")}</button>
                <button class="btn-select" onClick={onApply} >{t("اختيار")}</button>
            </div>

        </div>
    </div>
    )
        
}