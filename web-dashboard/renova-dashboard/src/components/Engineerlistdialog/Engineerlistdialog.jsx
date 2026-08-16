import "./Engineerlistdialog.css";
//MUI
import EngineeringIcon from '@mui/icons-material/Engineering';
import ClearIcon from '@mui/icons-material/Clear';
import CheckIcon from '@mui/icons-material/Check';
//Hooks
import { useTranslation } from 'react-i18next';
//Components
import Button from '../Button/Button';
import Dialogform from "../Dialogform/Dialogform";
export default function Engineerlistdialog({children,onClose,onApply}) {
    const {t}=useTranslation();
    return(
        <Dialogform 
        title={"اختيار مهندس"} 
        icon={<EngineeringIcon sx={{color: "#f07c1f",fontSize:30}} /> }
        h="625px" 
        w="520px"
        b1={<Button className="cancel" onClick={onClose} text="إلغاء" icon={<ClearIcon/>}/>}
        b2={<Button className="accept" onClick={onApply} text="اختيار" icon={<CheckIcon/>}/>}
        >
            <div className="engineerslist">
                {children}      
            </div>
        </Dialogform>
        

    
        
    )
        
}
