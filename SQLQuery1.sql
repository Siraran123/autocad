DECLARE @bomId int = 259549

SELECT  bd.bomDetailId
       ,bd.partId
       ,pn.pn AS PartName
       ,pn.description AS PartNameDescription
       ,bd.bomId
       ,bd.isActive
       ,bd.parentBomDetailId
       ,pnp.partId parentPartId
       ,pnp.pn AS parentPartName
       ,pnp.description AS parentPartDescription
       ,bd.bomLevel
       ,bd.qty
       ,bd.uom
       ,bd.matType
       ,bd.matGroup
       ,bd.msi
       ,bd.ecoNumber
       ,pn.customerPn
       ,pn.serializedFlag
       ,bd.phantom
FROM tbBomDetail as bd
       LEFT JOIN tbBomDetail AS pbd on bd.parentBomDetailId = pbd.bomDetailId
       LEFT JOIN tbPartNumber AS pn ON bd.partId = pn.partId
       LEFT JOIN tbPartNumber AS pnp ON pbd.partId = pnp.partId
WHERE 
--dbo.fnCheckParentPN(bd.bomDetailId) = 1 and 
bd.bomId = @bomId and bd.isActive = 1 and bd.isDeleted = 0 and 
(SUBSTRING(bd.matGroup,LEN(bd.matGroup) -3,4) not in ('4337','4336') 
or bd.bomDetailId in(select bomDetailId from tbBomDetail tbd  where tbd.bomId  = 259549 and bomLevel=1 and uom is not null)
)
and dbo.fnCheckParentPN(bd.bomDetailId) =1
and (bd.parentBomDetailId not in (
select tbd.bomDetailId from  tbBomDetail tbd  where tbd.bomId  = @bomId  and tbd.matType ='HALB' and ISNUMERIC(SUBSTRING(tbd.matGroup,LEN(tbd.matGroup) -3,4))   = 1
union
select tbd.bomDetailId from tbBomDetail tbd  where tbd.bomId  = @bomId  and  isnull(tbd.phantom,'') ='' and SUBSTRING(tbd.matGroup,LEN(tbd.matGroup)-3,4)  ='HNPI')  
or bd.parentBomDetailId is null)
--and pn.pn ='0250-60918-02A8S'
ORDER BY bd.bomLevel asc ;

select bomDetailId from tbBomDetail tbd  where tbd.bomId  = 259549 and bomLevel=1 and uom is not null

--select count(*) from tbBomDetail  where bomId  = @bomId 

--select * from tbBomDetail  where bomDetailId  = 60200 
--select * from tbBomDetail  where bomDetailId  = 60200 



--select * from tbBom  where bomId  =259549


