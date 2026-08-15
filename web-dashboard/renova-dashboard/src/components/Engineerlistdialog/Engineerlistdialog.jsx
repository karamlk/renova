import "./Engineerlistdialog.css";
//MUI Icons
import EngineeringIcon from '@mui/icons-material/Engineering';
import ClearIcon from '@mui/icons-material/Clear';
import CheckIcon from '@mui/icons-material/Check';
//Hooks
import { useTranslation } from 'react-i18next';
//Components
import Button from '../Button/Button';
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
                <Button className="cancel" onClick={onClose} text="إلغاء" icon={<ClearIcon/>}/>
                <Button className="accept" onClick={onApply} text="اختيار" icon={<CheckIcon/>}/>
            </div>

        </div>
    </div>
    )
        
}