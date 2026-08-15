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
export default function Filterdialog({onClose,title,groups,onApply,onReset,selectedFilters,setSelectedFilters}) {
    const [t] = useTranslation();
    return (
    <div className="filter-overlay">
        <div className="filter-dialog">
        
            <div className="filter-header">
                <div className="filter-title">
                    <FilterAltIcon sx={{color:"#f07c1f" ,fontSize:30}} />
                    <h3>{t(title)}</h3>
                </div>
                <button className="filter-close-btn" onClick={onClose}>
                    <ClearIcon fontSize="small"/>
                </button>
            </div>
            <div className="filter-body">
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
            </div>
            <div className="filter-footer">
                <Button className="cancel" onClick={onReset} text="إعادة تعيين" icon={<ReplayIcon/>}/>
                <Button className="accept" onClick={()=>{onApply(selectedFilters);}} text="تطبيق الفلتر" icon={<CheckIcon/>}/>
            </div>

        </div>
    </div>
    )
}