import "./Filterdialog.css";
//MUI Icons
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import ClearIcon from '@mui/icons-material/Clear';
import ReplayIcon from '@mui/icons-material/Replay';
import CheckIcon from '@mui/icons-material/Check';
//Hooks
import { useTranslation } from 'react-i18next';
//Components
import Button from '../Button/Button';
import Dialogform from "../Dialogform/Dialogform";
export default function Filterdialog({onClose,title,groups,onApply,onReset,selectedFilters,setSelectedFilters}) {
    const [t] = useTranslation();
    return (
        <div>
    <Dialogform
        title={title} 
        icon={<FilterAltIcon sx={{color:"#f07c1f" ,fontSize:30}} />}
        h="60vh" 
        w="460px"
        b1={<Button className="cancel" onClick={onReset} text="إعادة تعيين" icon={<ReplayIcon/>}/>}
        b2={<Button className="accept" onClick={()=>{onApply(selectedFilters);}} text="تطبيق الفلتر" icon={<CheckIcon/>}/>}
        closebtn={<button className="filter-close-btn" onClick={onClose}><ClearIcon fontSize="small"/></button>}
        >
                {groups.map((group) => (
                    <div className="filter-group" key={group.name}>
                    <span className="group-label">{group.icon}{t(group.subtitle)}</span>
                    <div className="filter-options">
                        {group.options.map((option) => (
                            <label className="filter-option" key={option.value}>
                            <input type="radio" name={group.name} value={option.value} checked={selectedFilters[group.name] === option.value} onChange={(e)=> setSelectedFilters({...selectedFilters,[group.name]: e.target.value})}/>
                            <span className="option-label">{t(option.label)}</span>
                        </label>
                        ))}
                    </div>
                </div>
                ))}            
        </Dialogform>
        </div>
    )
}